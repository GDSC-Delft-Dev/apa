from .module import Module
from .data import Data
from .types import Modules
import cv2
import numpy as np


class Preprocess(Module):
    """
    Perform data preprocessing on raw images.
    """
    def __init__(self, data: Data, input: any):
        super(Preprocess, self).__init__("Preprocesisng", Modules.PREPROCESS, data)
        data.modules[self.type] = {
            "masks": input
        }

    """
    Preprocesses the image(s) by multiplying by their respective mask, if any.

    Args:
        img: the images to preprocess
        rest: masks for each image in img or None
    
    Returns:
        The preprocessed image(s).
    """ 
    def run(self, img: list[cv2.Mat], rest: any) -> list[cv2.Mat]:
        self.prepare() 
        if rest == None:
            return super().run(img, rest=None, save=True)
        # apply masks to eliminate invalid areas in images
        masked = [cv2.multiply(x, mask) for (x, mask) in zip(img, rest)]
        return super().run(masked, rest=None, save=True)



class AgricultureVisionPreprocess(Preprocess):

    """
    Perform data preprocessing on Agriculture-Vision: A Large Aerial Image Database for
    Agricultural Pattern Analysis dataset. 
    
    The preprocessing applied is inspired from the 'Farmland image preprocessing' section in
    the corresponding paper.
    """

    def __init__(self):
        super(AgricultureVisionPreprocess, self).__init__("Agriculture Vision dataset preprocessing")

 
    """
    Preprocesses the image(s) by multiplying by their respective mask provided by the dataset.
    Then, clip the values in the image between 5th percentile and 95th percentile.

    Args:
        img: the images to preprocess
        rest: masks for each image in img

    Returns:
        The preprocessed image(s).
    """    
    def run(self, img: list[cv2.Mat], rest: any) -> list[cv2.Mat]:

        self.prepare()
        # apply masks to eliminate invalid areas in images

        masked = [cv2.multiply(x, mask) for (x, mask) in zip(img, rest)]

        percentiles = [(np.percentile(x, 5), np.percentile(x, 95)) for x in masked]
        bounds = [(max(0.0, p5 - 0.4 * (p95 - p5)), min(255.0, p95 + 0.4*(p95-p5))) 
                    for (p5, p95) in percentiles]
        clipping = [np.clip(x, v_lower, v_upper).astype(np.uint8) for (x, (v_lower, v_upper)) in zip(img, bounds)]
        return super(Preprocess, self).run(clipping, rest=None, save=True)