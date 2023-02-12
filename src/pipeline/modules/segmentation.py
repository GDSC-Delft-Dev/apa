from modules.module import Module
from tensorflow import keras
import numpy as np
import cv2

"""
Base module for performing image segmentation techniques.
"""
class Segmentation(Module):
    def __init__(self, name: str = "Segmentation"):
        super().__init__(name)

"""
Perform semantic segmentation using the DeepLabV3+ model.
"""
class SemanticSegmentation(Segmentation):

    def __init__(self, model_path: str):
        super(SemanticSegmentation, self).__init__("Semantic Segmentation DeepLabv3+")
        self.model_path = model_path # path to the saved model

    """
    Load the model from a specified location.

    Args:
    """
    def prepare(self):
        print(f"Loading saved model {self.model_path}")
        self.model = keras.models.load_model(self.model_path)
        print(f"Running module <{self.name}>")

    """
    Perform inference using the images given.
    Each image should adhere to specific dimensions in order to be
    used by the model.
    The model returns a mask for each of the predefined labels that can be
    used to highlight areas of interest.

    Args:
        img: the input image(s)
        rest: non-specific module arguments
    """
    def run(self, img: list[cv2.Mat], rest: any):
        self.prepare()
        predictions = []
        for image in img:
            predictions.append(self.model.predict(np.expand_dims((image), axis=0)))
            print(predictions[-1].shape)

        if self.next != None:
            self.next.run(img, None)
   