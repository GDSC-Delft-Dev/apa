from ..insight import Insight
from ...data import Data
from ...runnable import Runnable
from ....ml.utils import Args
from ....mat import Channels
import tensorflow as tf

# TODO: take this from somewhere else
MODEL_PATH = ""

class TomatoDiseaseInsight(Runnable):
    """Decide if the crop is healthy or not. If the crop is not healthy, 
    determine the disease."""

    def __init__(self, data: Data, name: str = "Tomato disease insight"):
        """
        Initializes the insight.

        Args:
            data - data object from the pipeline
            name - name of the insight
        """
        super().__init__(data, name, channels=[Channels.R, Channels.G, Channels.B])


    def run(self, data: Data):   
        """
        Executes the logic of the runnable.

        Args:
            data: the pipeline data object
        """

        assert data.modules["plant_preprocessing"]["images"] is not None 
        # assume a module takes care of all preprocessing steps
        imgs = data.modules["plant_preprocessing"]["images"]
        model = tf.keras.models.load_model(MODEL_PATH)

        labels = model.predict(imgs)
        labels = tf.argmax(labels, axis=1)

        # TODO: should have a separate ENUM with a specific disease name
        # TODO: save them
        mapping = [Args.classes[i] for i in labels]

    def prepare(self, data: Data):
        """
        Prepares the runnable to be run by initializing the space in the
        pipeline data object.

        Args:
            data: the pipeline data object
        """
        pass 

    def upload(self, data: Data, collection, bucket, base_url: str):
        """
        Upload data to Google Cloud Storage.

        Args:
            data: the pipeline data object
            collection: Firestore collection 
            storage_client: Cloud Storage client
            base_url: base url where data is persisted
        """
        pass

    def to_persist(self, data: Data):
        """
        Define what objects to persist for the runnable.

        Args:
            data: the pipeline data object
        """
        pass
