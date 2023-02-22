from modules.module import Module
from tensorflow import keras
from .data import Data
from .modules import Modules
import numpy as np
from typing import Any

class SemanticSegmentation(Module):
    """Perform semantic segmentation using the DeepLabV3+ model."""

    def __init__(self, data: Data, input_data: Any) -> None:
        super().__init__(data, name="Semantic Segmentation DeepLabv3+", module_type=Modules.SEGMENTATION)
        self.paths = input # paths to model atrifacts 

    def run(self, data: Data) -> Data:
        """
        Perform inference using the images given.
        Each image should adhere to specific dimensions in order to be
        used by the model.
        The model returns a mask for each of the predefined labels that can be
        used to highlight areas of interest.

        Args:
            data: the pipeline data object with the input images
        """

        model = keras.models.load_model(self.paths[len(data.input[0].channels)])
        predictions = []
        for image in data.modules[Modules.PREPROCESS]["clipping"]:
            predictions.append(model.predict(np.expand_dims((image.get()), axis=0)))

        data.modules[self.type]["masks"] = predictions
        return super().run(data)
   
