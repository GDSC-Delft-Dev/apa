from modules.module import Module
from modules.mosaicing import Mosaicing
from modules.preprocess import Preprocess, AgricultureVisionPreprocess
import cv2
from mat import Mat
from modules.data import Data
from config import Config
import copy

class Pipeline:
    """
    Build the pipeline according to the configuration.
    """
    def __init__(self, config: Config):
        self.head: Module = None

        # Build the data object
        self.data_proto: Data = Data()

        # Build the modules chain
        tail: Module = None
        for module in config.modules:
            if self.head is None:
                self.head = module(self.data_proto)
                tail = self.head
            else:
                self.tail.next = module(self.data_proto)
                tail = tail.next

    """
    Runs the pipeline on the provided input images.

    Args:
        img: the input image(s)
        rest: non-specific module arguments

    Returns:
        The processed data.
    """
    def run(self, img: Mat | list[Mat]) -> Data:
        # Construct input data
        data = copy.deepcopy(self.data_proto)
        data.set(img)

        # Run the chain
        self.head.run(data)
        return data