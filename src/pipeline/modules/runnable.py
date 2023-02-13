import cv2
from abc import ABC, abstractmethod
from .data import Data

"""
Represents arbitrary runnable logic for image procesing.
"""
class Runnable(ABC):
    def __init__(self, name: str, data: Data):
        self.name: str = name

    """
    Executes the logic of the runnable.
    """
    @abstractmethod
    def run(self, data: Data):      
        pass

    """
    Prepares the runnable to be run by initializing the space in the
    pipeline data object.
    """
    @abstractmethod
    def prepare(self, data: Data):
        pass
