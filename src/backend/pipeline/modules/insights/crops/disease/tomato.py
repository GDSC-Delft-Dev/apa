from ...insight import Insight
from ....data import Data
from .....ml.utils import Args
import tensorflow as tf

# TODO: take this from somewhere else
MODEL_PATH = ""

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

        assert self.data.modules["plant_preprocessing"]["images"] is not None 
        # assume a module takes care of all preprocessing steps
        imgs = self.data.modules["plant_preprocessing"]["images"]
        model = tf.keras.models.load_model(MODEL_PATH)

        labels = model.predict(imgs)
        labels = tf.argmax(labels, axis=1)

        # TODO: should have a separate ENUM with a specific disease name
        # TODO: save them
        mapping = [Args.classes[i] for i in labels]
        return True
