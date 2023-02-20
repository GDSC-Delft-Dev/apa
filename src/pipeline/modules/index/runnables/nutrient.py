from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from mat import Channels
import numpy as np
import matplotlib.pyplot as plt
import cv2

"""
Nutrient deficiency runnable.
"""
class Nutrient(Runnable):

    def __init__(self, data: Data):
        super().__init__("NUTRIENT", data)
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
        except Exception as e:
            print("Nutrient calculation failed!")
            print(e)
            return False

    """
    Applies the masks on the patches and then concats into the mosaic image.

    Args:
        masks: masks for each of the pathes
        patches: cropped parts of fixed size from the mosaic image

    Returns:
        Nutrient deficit map
    """
    def calculate(self, masks, patches) -> list[np.array]:
        results = [cv2.addWeighted(mask, 1, image, 1, 0, image) for mask, image in zip(masks, patches)]
        # TODO: concat the results
        return results

    """
    Prepares the Nutrient deficit data space.

    Args:
        data: the pipeline data object
    """
    def prepare(self, data: Data):
        super().prepare(data)
        data.modules[Modules.INDEX]["runnables"][self.type] = {}

            


