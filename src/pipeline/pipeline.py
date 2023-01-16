from modules.module import Module
from modules.mosaicing import Mosaicing
import cv2

class Pipeline:
    def __init__(self):
        self.chain: Module = Mosaicing()

    """
    Runs an instance of the pipeline

    Args:
        img: the input image(s)
        rest: non-specific module arguments
    """
    def run(self, img: cv2.Mat | list[cv2.Mat], rest: any):
        res = self.chain.run(img, rest)
        print(res)