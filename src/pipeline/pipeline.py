from modules.module import Module
from modules.mosaicing import Mosaicing
import cv2
from mat import Mat
from modules.index.index import Index
from modules.data import Data
import copy

class Pipeline:
    """
    Build the pipeline according to the configuration.
    """
    def __init__(self, config: Config):
        self.chain: Module = None

        # Build the modules chain
        tail = self.chain
        for module in config.modules:
            tail = module.__init__()
            tail = tail.next

        # Build the data object
        self.data_proto: Data = Data()

    """
    Runs the pipeline on the provided input images.

    Args:
        img: the input image(s)
        rest: non-specific module arguments
    """
    def run(self, img: Mat | list[Mat]):
        # Construct input data
        data = copy.deepcopy(self.data_proto)
        data.set(img)

        # Run the chain
        res = self.chain.run(data)
        print(res)