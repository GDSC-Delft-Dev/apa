from ..insight import Insight
from ...data import Data
from ...modules import Modules
from ...runnable import Runnable
from ....ml.utils import Args
from ....mat import Channels
from ..insights import Insights, insights_mapping
import tensorflow as tf
import numpy as np
import os

MODEL_PATH = "pipeline/ml/tomato_model/resnet_tomato"

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
        assert data.modules[Modules.PREPROCESS.value]["standard"] is not None
        # assume a module takes care of all preprocessing steps
        imgs = data.modules[Modules.PREPROCESS.value]["standard"]
        model = tf.keras.models.load_model(MODEL_PATH)
        labels = model.predict(np.array([x.get() for x in imgs]))
        labels = tf.argmax(labels, axis=1)
        # Map index to disease
        mapping = [insights_mapping[Insights.TOMATO](i).name for i in labels]
        data.modules[Modules.INSIGHT.value]["runnables"][self.type.value] = mapping

    def prepare(self, data: Data):
        """
        Prepares the runnable to be run by initializing the space in the
        pipeline data object.

        Args:
            data: the pipeline data object
        """
        data.modules[Modules.INSIGHT.value]["runnables"][self.type.value] = {}
        self.to_persist(data)

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
        persist: str = Modules.INSIGHT.value + "." + "runnables" + "." + \
                            self.type.value + "." + "index"
        data.persistable[Modules.INSIGHT.value]["runnables"]\
                        [self.type.value] = frozenset([persist])
