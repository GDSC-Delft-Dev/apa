from abc import ABC, abstractmethod
from ..data import Data

class Insight(ABC):
    """Represents an arbitrary insight"""

    def __init__(self, data: Data, name: str = "Undefined insight"):
        """
        Initializes the insight.

        Args:
            data - data object from the pipeline
            name - name of the insight
        """

        self.data: Data = data
        self.name: str = name

    @abstractmethod
    def run(self) -> bool:
        """
        Insight inference.
        """
        pass
