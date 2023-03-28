from ...insight import Insight
from ....data import Data
import tensorflow as tf

class TomatoDiseaseInsight(Insight):
    """Decide if the crop is healthy or not. If the crop is not healthy, 
    determine the disease."""

    def __init__(self, data: Data, name: str = "Tomato disease insight"):
        """
        Initializes the insight.

        Args:
            data - data object from the pipeline
            name - name of the insight
        """

        super().__init__(data, name)

    def run(self) -> bool:
        """
        Insight inference.
        """
        pass