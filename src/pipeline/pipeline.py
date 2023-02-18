from modules.module import Module
from modules.mosaicing import Mosaicing
from modules.segmentation import Segmentation, SemanticSegmentation
import cv2

class Pipeline:
    def __init__(self):
        MODEL_PATH = "./ml/deepv3_seg"
        self.chain: Module = SemanticSegmentation(MODEL_PATH)

    """
    Runs an instance of the pipeline

    Args:
        img: the input image(s)
        rest: non-specific module arguments
    """
    def run(self, img: cv2.Mat | list[cv2.Mat], rest: any):
        res = self.chain.run(img, rest)
        print(res)
