from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from ....mat import Channels
import numpy as np
import matplotlib.pyplot as plt
import cv2

class Nutrient(Runnable):
    """
    Nutrient deficiency runnable.
    """

    def __init__(self, data: Data) -> None:
        super().__init__(data, name="NUTRIENT")
        self.type = Indicies.NUTRIENT

    def run(self, data: Data) -> bool:
        try:
            # take the calculated masks from the segmentation module
            masks = data.modules[Modules.SEGMENTATION.value]["masks"]
            # assume index 0 is for the nutrient deficiency mask
            nutrient_masks = [mask[0][:, :, 0] for mask in masks]
            data.modules[Modules.INDEX.value]["runnables"][self.type.value]["masks"] = nutrient_masks
            masks = [np.where(mask == 1, 255, 0) for mask in nutrient_masks]
            patches = data.modules[Modules.MOSAIC.value]["patches"]
            hsize = 512
            result = self.calculate(masks, patches, hsize)
            data.modules[Modules.INDEX.value]["runnables"][self.type.value]["index"] = result
            return True
        except Exception as exception:
            print("Nutrient calculation failed!")
            print(exception)
            return False

    def calculate(self, masks, patches, hsize: int) -> np.ndarray:
        """
        Applies the masks on the patches and then concats into the mosaic image.

        Args:
            masks: masks for each of the pathes
            patches: cropped parts of fixed size from the mosaic image
            hsize: horizontal number of patches that reconstruct the original image

        Returns:
            Nutrient deficit map
        """
        def gray_to_rgb(value: np.ndarray):
            """
            Grayscale image to RGB.
            Used to duplicate channels. 
            """
            return cv2.cvtColor(value.astype(np.uint8),cv2.COLOR_GRAY2RGB) 
        # overlay the masks over the patches
        results = [cv2.addWeighted(gray_to_rgb(mask), 1, image.get(), 1, 0) for mask, image in zip(masks, patches)]
        # stack patches horizontally
        row_results = [np.hstack(results[i:i+hsize]) for i in range(0, len(results), hsize)]
        # final image after overlaying the calculated masks on the respective patches
        # reconstructed image
        final_img = np.vstack(row_results)
        return final_img

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
        