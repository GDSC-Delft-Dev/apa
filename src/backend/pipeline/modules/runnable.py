from __future__ import annotations
from abc import ABC, abstractmethod
from .data import Data
from ..mat import Channels

class Dependencies:
    """Represents the dependencies of a runnable."""

    def __init__(self, bands: list[Channels] = [], runnables: list[str] = []):
        self.bands: list[Channels] = []
        self.runnables: list[str] = []

    def delta(self, other: Dependencies) -> Dependencies:
        """
        Returns the difference between two dependencies.

        Args:
            other: the other dependencies

        Returns:
            The difference between the two dependencies.
        """
        return Dependencies(
            bands = list(set(self.bands) - set(other.bands)),
            runnables = list(set(self.runnables) - set(other.runnables)))
    
    def empty(self) -> bool:
        """
        Returns whether the dependencies are empty, i.e. satisfied.

        Returns:
            Whether the dependencies are empty.
        """
        return len(self.bands) == 0 and len(self.runnables) == 0

class Runnable(ABC):
    """Represents arbitrary runnable logic for image processing."""

    def __init__(self, _data: Data, name: str = "Unnamed runnable", dependencies: Dependencies = Dependencies()):
        """
        Initializes the runnable.

        Args:
            str: the name of the runnable
            data: the pipeline data object
        """
        self.name: str = name
        self.dependencies: Dependencies = dependencies

    def verify(self, satisfied: Dependencies) -> Dependencies:
        """
        Verifies whether the runnable's dependencies are satisfied.

        Args:
            satisfied: the satisfied dependencies

        Returns:
            The unsatisfied dependencies.
        """
        return self.dependencies.delta(satisfied)
    
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
