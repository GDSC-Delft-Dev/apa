from modules.module import Module
from modules.mosaicing import Mosaicing
from modules.segmentation import SemanticSegmentation
import cv2
from mat import Mat
from modules.data import Data
from config import Config
import copy
import numpy as np
from typing import Any, Type

class Pipeline:
    """
    Build the pipeline according to the configuration.
    """
    def __init__(self, config: Config):
        # Build the data object
        self.data_proto: Data = Data()
        
        # Build the head
        kv = next(iter(config.modules.items()))
        self.head: Module = kv[0](self.data_proto, input=kv[1])

        # Build the rest
        tail: Module = self.head
        for module, input in list(config.modules.items())[1:]: #type: tuple[Type[Module], Any]
            tail.next = module(self.data_proto, input=input)
            tail = tail.next

    """
    Runs the pipeline on the provided input images.

    Args:
        img: the input image(s)
        rest: non-specific module arguments

    Returns:
        The processed data.
    """
    def run(self, imgs: Mat | list[Mat]) -> Data:
        # Verify input integrity
        # Check that the channels of all images are the same
        if not isinstance(imgs, Mat):
            channels = [img.channels for img in imgs]
            assert(channels.count(channels[0]) == len(channels))

        # Construct input data
        data = copy.deepcopy(self.data_proto)
        data.set(imgs)

        # Run the chain
        self.head.run(data)
        return data
        
    """
    Prints out the current state of the pipeline.
    """
    def show(self):
        print("-- Pipeline --")
        tail = self.head
        while tail:
            print(f"<{tail.name}>")
            tail = tail.next
        print("----")
