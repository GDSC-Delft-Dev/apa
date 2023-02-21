import cv2
from abc import ABC, abstractmethod
from .data import Data

"""
Represents arbitrary runnable logic for image processing.
"""
class Runnable(ABC):
    """
    Initializes the runnable.

    Args:
        str: the name of the runnable
        data: the pipeline data object
    """
    def __init__(self, data: Data, name: str = "Unnamed runnable"):
        self.name: str = name

    """
    Executes the logic of the runnable.

    Args:
        data: the pipeline data object
    """
    @abstractmethod
    def run(self, data: Data):      
        pass

    """
    Prepares the runnable to be run by initializing the space in the
    pipeline data object.

    Args:
        data: the pipeline data object
    """
    @abstractmethod
    def prepare(self, data: Data):
        pass
