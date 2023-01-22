from ...runnable import Runnable
from ...data import Data
import cv2

class NDVI(Runnable):
    def __init__(self):
        super().__init__("NDVI")

    """
    Computes the NDVI map on the processed image.
    """
    def run(self, data: Data):
        pass