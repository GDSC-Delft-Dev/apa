from .module import Module
from .data import Data
from .modules import Modules
from mat import Mat
import cv2
import numpy as np


class Preprocess(Module):
    """
    Perform data preprocessing on raw images.
    """
    def __init__(self, data: Data, input: any):
        super().__init__("Preprocesisng", Modules.PREPROCESS, data)
        self.masks = input
    """
    Preprocesses the image(s) by multiplying by their respective mask, if any.

    Args:
        img: the images to preprocess
        rest: masks for each image in img or None
    
    Returns:
        The preprocessed image(s).
    """ 
    def run(self, data: Data):
        if self.masks is None: # there are no masks available
            data.modules[self.type]["masked"] = data.input
        else: # Apply masks to eliminate invalid areas in images 
            masked = [Mat(cv2.multiply(x.get(), mask), data.input[0].channels) for (x, mask) in zip(data.input, self.masks)]
            data.modules[self.type]["masked"] = masked
        return super().run(data)

class AgricultureVisionPreprocess(Preprocess):

    """
    Perform data preprocessing on Agriculture-Vision: A Large Aerial Image Database for
    Agricultural Pattern Analysis dataset. 
    
    The preprocessing applied is inspired from the 'Farmland image preprocessing' section in
    the corresponding paper.
    """
    def __init__(self, data: Data, input: any):
        super().__init__(data, input)
 
    """
    Preprocesses the image(s) by multiplying by their respective mask provided by the dataset.
    Then, clip the values in the image between 5th percentile and 95th percentile.

    Args:
        img: the images to preprocess
        rest: masks for each image in img

    Returns:
        The preprocessed image(s).
    """    
    def run(self, data: Data):  
        if self.masks is None: # there are no available masks for the input data
            masked = [x.get() for x in data.modules[Modules.MOSAIC]["patches"]]
        else: # apply masks to eliminate invalid areas in images
            masked = [cv2.multiply(x.get(), mask) 
                for (x, mask) in zip(data.modules[Modules.MOSAIC]["patches"], self.masks)]

        # calculate the 5th and 95th percentile in the data
        percentiles = [(np.percentile(x, 5), np.percentile(x, 95)) for x in masked]
        # create lower and upper bounds based on the percentiles
        bounds = [(max(0.0, p5 - 0.4 * (p95 - p5)), min(255.0, p95 + 0.4*(p95-p5))) 
                    for (p5, p95) in percentiles]
        # use the created bounds to clip the input data
        data.modules[self.type]["clipping"] =\
            [Mat(np.clip(x.get(), v_lower, v_upper).astype(np.uint8), data.input[0].channels) 
                for (x, (v_lower, v_upper)) in zip(data.modules[Modules.MOSAIC]["patches"], bounds)]
        return super().run(data)