import cv2
from abc import ABC, abstractmethod
from .data import Data

"""
Represents arbitrary runnable logic for image procesing.
"""
class Runnable(ABC):
    def __init__(self, name: str):
        self.name: str = name

    """
    Abstract function for running the arbitrary logic.
    """
    @abstractmethod
    def run(self, data: Data, persist: bool = False) -> cv2.Mat:
        pass

    """
    Prepares the runnable to be run.
    """
    def prepare(self, data: Data):
        print(f"Running runnable <{self.name}>")
        data.stages[-1]["runnables"][self.name] = {
            "name": self.name
        }
