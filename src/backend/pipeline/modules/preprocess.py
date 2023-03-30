from .module import Module
from .data import Data
from .modules import Modules
from ..mat import Mat
import cv2
from typing import Any
import numpy as np


class Preprocess(Module):
    """Perform data preprocessing on raw images."""

    def __init__(self, data: Data, input_data: Any):
        super().__init__(data, name="Preprocesisng", module_type=Modules.PREPROCESS)
        self.masks: list[Mat] = input_data
        
    def run(self, data: Data):
        """
        Preprocesses the image(s) by multiplying by their respective mask, if any.

        Args:
            img: the images to preprocess
            rest: masks for each image in img or None
        
        Returns:
            The preprocessed image(s).
        """ 
        if self.masks is None: # there are no masks available
            data.modules[self.type.value]["masked"] = data.input
        else: # Apply masks to eliminate invalid areas in images 
            masked: list[Mat] = [Mat(cv2.multiply(x.get(), mask), data.input[0].channels)
                                 for (x, mask) in zip(data.input, self.masks)] 
            data.modules[self.type.value]["masked"] = masked

        return super().run(data)
    
class StandardizePreprocess(Preprocess):
    """
    Perform data preprocessing on raw images by standardizing them.

    The module only accepts images with 3 channels.
    """

    def __init__(self, data: Data, input_data: Any):
        super().__init__(data, input_data=input_data)

    def run(self, data: Data):
        """
        Preprocesses the image(s) by standardizing them.

        Args:
            img: the images to preprocess

        Returns:
            The preprocessed image(s).
        """ 
        assert data.input[0].channels == 3, "Standardization only works for RGB images."
        mean: list[float] = [0.485, 0.456, 0.406] 
        stddev: list[float] = [0.229, 0.224, 0.225]
        standardize: list[Mat] = [Mat(np.divide((x.get() - mean), stddev), data.input[0].channels)
                                 for x in data.input]
        data.modules[self.type.value]["standard"] = standardize
        return super().run(data)

class AgricultureVisionPreprocess(Preprocess):
    """
    Perform data preprocessing on Agriculture-Vision: A Large Aerial Image Database for
    Agricultural Pattern Analysis dataset. 
    
    The preprocessing applied is inspired from the 'Farmland image preprocessing' section in
    the corresponding paper.
    """

    def __init__(self, data: Data, input_data: Any):
        super().__init__(data, input_data=input_data)
   
    def run(self, data: Data):  
        """
        Preprocesses the image(s) by multiplying by their respective mask provided by the dataset.
        Then, clip the values in the image between 5th percentile and 95th percentile.

        Args:
            img: the images to preprocess
            rest: masks for each image in img

        Returns:
            The preprocessed image(s).
        """  

        if self.masks is None: # there are no available masks for the input data
            masked = [x.get() for x in data.modules[Modules.MOSAIC.value]["patches"]]
        else: # apply masks to eliminate invalid areas in images
            masked = [cv2.multiply(x.get(), mask) 
                for (x, mask) in zip(data.modules[Modules.MOSAIC.value]["patches"], self.masks)]

        # calculate the 5th and 95th percentile in the data
        percentiles = [(np.percentile(x, 5), np.percentile(x, 95)) for x in masked]
        # create lower and upper bounds based on the percentiles
        bounds = [(max(0.0, p5 - 0.4 * (p95 - p5)), min(255.0, p95 + 0.4*(p95-p5))) 
                    for (p5, p95) in percentiles]
        # use the created bounds to clip the input data
        data.modules[self.type.value]["clipping"] =\
            [Mat(np.clip(x.get(), v_lower, v_upper).astype(np.uint8), data.input[0].channels) 
                for (x, (v_lower, v_upper)) in zip(data.modules[Modules.MOSAIC.value]["patches"], bounds)]
        return super().run(data)
