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
    def __init__(self, config: any):
        # Build the chain
        self.chain: Module = Mosaicing()
        self.chain.next = Index()

        # Build the data object
        self.data_proto: Data = Data()

    """
    Runs an instance of the pipeline

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