from abc import ABC, abstractmethod
from .data import Data

class Runnable(ABC):
    """Represents arbitrary runnable logic for image processing."""

    def __init__(self, _data: Data, name: str = "Unnamed runnable"):
        """
        Initializes the runnable.

        Args:
            str: the name of the runnable
            data: the pipeline data object
        """
        self.name: str = name

    
    @abstractmethod
    def run(self, data: Data):   
        """
        Executes the logic of the runnable.

        Args:
            data: the pipeline data object
        """   

    @abstractmethod
    def prepare(self, data: Data):
        """
        Prepares the runnable to be run by initializing the space in the
        pipeline data object.

        Args:
            data: the pipeline data object
        """
