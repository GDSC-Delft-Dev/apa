from __future__ import annotations
from abc import ABC, abstractmethod
from .data import Data
from ..mat import Channels

class Runnable(ABC):
    """Represents arbitrary runnable logic for image processing."""

    def __init__(self, _data: Data, name: str = "Unnamed runnable", channels: list[Channels] = []):
        """
        Initializes the runnable.

        Args:
            str: the name of the runnable
            data: the pipeline data object
        """
        self.name: str = name
        self.channels: list[Channels] = channels

    def verify(self, channels: list[Channels]) -> bool:
        """
        Verifies that the runnable can be run on the provided channels.

        Args:
            channels: the channels to verify

        Returns:
            True if the runnable can be run on the provided channels,
            False otherwise.
        """

        misisng: list[Channels] = set(self.channels) - set(channels)
        if len(misisng) > 0:
            print(f"Runnable {self.name} is missing the following channels: {misisng}")
            return False

        return True

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