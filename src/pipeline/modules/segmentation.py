from modules.module import Module
from tensorflow import keras
from .data import Data
from .modules import Modules
import numpy as np
import cv2

"""
Perform semantic segmentation using the DeepLabV3+ model.
"""
class SemanticSegmentation(Module):

    def __init__(self, data: Data, input: any):
        super(SemanticSegmentation, self).__init__("Semantic Segmentation DeepLabv3+", 
            Modules.SEGMENTATION, data)
        self.paths = input # paths to model atrifacts 

    """
    Perform inference using the images given.
    Each image should adhere to specific dimensions in order to be
    used by the model.
    The model returns a mask for each of the predefined labels that can be
    used to highlight areas of interest.

    Args:
        data: the pipeline data object with the input images
    """
    def run(self, data: Data):
        model = keras.models.load_model(self.paths[len(data.input[0].channels)])
        predictions = []
        for image in data.modules[Modules.PREPROCESS]["clipping"]:
            predictions.append(model.predict(np.expand_dims((image.get()), axis=0)))

        data.modules[self.type]["masks"] = predictions
        return super().run(data)
   
