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
            # TODO: see the actual mask order
            masks = data.modules[Modules.SEGMENTATION]["masks"][:, 0]
            masks = [np.where(mask.get() == 1, 255, 0) for mask in masks]
            patches = data.modules[Modules.SEGMENTATION]["patches"]
            results = self.calculate(masks, patches)
            data.modules[Modules.INDEX]["runnables"][self.type]["index"] = results
            return True
        except Exception as exception:
            print("Nutrient calculation failed!")
            print(exception)
            return False

    def calculate(self, masks, patches) -> list[np.ndarray]:
        """
        Applies the masks on the patches and then concats into the mosaic image.

        Args:
            masks: masks for each of the pathes
            patches: cropped parts of fixed size from the mosaic image

        Returns:
            Nutrient deficit map
        """
        results = [cv2.addWeighted(mask, 1, image, 1, 0, image) for mask, image in zip(masks, patches)]
        # TODO: concat the results
        return results

    def prepare(self, data: Data):
        """
        Prepares the Nutrient deficit data space.

        Args:
            data: the pipeline data object
        """
        super().prepare(data)
        data.modules[Modules.INDEX]["runnables"][self.type] = {}
