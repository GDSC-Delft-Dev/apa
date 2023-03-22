from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from ....mat import Channels
from .generic import GenericIndex
from ....mat import Mat
import numpy as np
import matplotlib.pyplot as plt
import cv2

class Nutrient(GenericIndex):
    """
    Nutrient deficiency runnable.
    """

    def __init__(self, data: Data) -> None:
        super().__init__(data, name="NUTRIENT", color_map="RdYlGn", 
                         channels=[Channels.R, Channels.G, Channels.B], index_type=Indicies.NUTRIENT)
        self.type = Indicies.NUTRIENT

    def run(self, data: Data) -> bool:
        try:
            hdim, _ = data.modules[Modules.MOSAIC.value]["patches_dims"]
            # take the calculated masks from the segmentation module
            masks = data.modules[Modules.SEGMENTATION.value]["masks"]
            # assume index 0 is for the nutrient deficiency mask
            nutrient_masks = [mask[0][:, :, 0] for mask in masks]
            data.modules[Modules.INDEX.value]["runnables"][self.type.value]["masks"] = nutrient_masks
            masks = [gray_to_rgb(np.where(mask == 1, 255, 0)) for mask in nutrient_masks]
            # create masked image
            self.mask = self.merge_patches(masks, hdim)
            patches = [x.get() for x in data.modules[Modules.MOSAIC.value]["patches"]]
            # reconstruct mosaic image
            img = self.merge_patches(patches, hdim)
            mat_img = Mat(img)
            # overlay masks over image
            result = self.calculate(mat_img)
            data.modules[Modules.INDEX.value]["runnables"][self.type.value]["index"] = result
            return True
        except Exception as exception:
            print("Nutrient calculation failed!")
            print(exception)
            return False
        
    def merge_patches(self, patches: list, hdim: int) -> np.ndarray:
        """
        Merge non-overlapping patches in a single image.

        Args:
            patches: list of non-overlapping patches to merge
            hdim: number of consecutive horizontal patches in the final image
        """
        # stack patches horizontally
        rows = [np.hstack(patches[i:i+hdim]) for i in range(0, len(patches), hdim)]
        # vertically stack created rows
        final  = np.vstack(rows)        
        return final


    def calculate(self, img: Mat) -> np.ndarray:
        """
        Applies the masked image to the mosaiced image.

        Args:
            img: the reconstructed mosaiced image

        Returns:
            Nutrient deficit map
        """
        masked_image = cv2.addWeighted(self.mask, 1, img.get(), 1, 0)
        return masked_image

    def prepare(self, data: Data):
        """
        Prepares the Nutrient deficit data space.

        Args:
            data: the pipeline data object
        """
        super().prepare(data)
        data.modules[Modules.INDEX.value]["runnables"][self.type.value] = {}

    def upload(self, data: Data, collection, bucket, base_url: str):
        pass
    
    def to_persist(self, data: Data):
        persist = Modules.INDEX.value + "." + "runnables" + \
                self.type.value + "index"
        data.persistable[Modules.INDEX.value]["runnables"][self.type.value] = frozenset([persist])


def gray_to_rgb(value: np.ndarray):
    """
    Grayscale image to RGB.
    Used to duplicate channels. 
    """
    return cv2.cvtColor(value.astype(np.uint8),cv2.COLOR_GRAY2RGB) 
        