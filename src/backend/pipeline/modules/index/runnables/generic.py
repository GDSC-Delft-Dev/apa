from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from ....mat import Mat, Channels
import numpy as np
from abc import abstractmethod
import traceback

class GenericIndex(Runnable):
    """Generic index runnable."""

    def __init__(self, data: Data, name: str, color_map: str,
                 channels: list[Channels], index_type: Indicies):
        """
        Initializes the generic index runnable.
        
        Args:
            data: the pipeline data object
            name: the name of the index
            color_map: the color map to used to display the index
            channels: the channels used to calculate the index
            index_type: the type of the index
        """
        super().__init__(data, name=name, channels=channels)
        self.type: Indicies = index_type
        self.color_map: str = color_map

    def run(self, data: Data) -> bool:
        """
        Prepares the channels and runs the index calculation.
        
        Args:
            data: the pipeline data object with the stitched images

        Returns:
            Whether the execution was successful.
        """
        try:
            # Get the channels
            index = self.calculate(data.modules[Modules.MOSAIC.value]["stitched"])
            
            # Calculate 
            data.modules[Modules.INDEX.value]["runnables"]\
                        [self.type.value]["index"] = index
            return True

        # Catch exception
        except Exception as exception:
            print("Running " + self.name + " failed: " + str(exception))
            traceback.print_exc()
            return False

    @abstractmethod
    def calculate(self, img: Mat) -> np.ndarray:
        """
        Calculates the index.
        
        Args:
            img: the image to calculate the index on
            
        Returns:
            The calculated index.
        """

    def to_persist(self, data: Data):
        persist: str = Modules.INDEX.value + "." + "runnables" + "." + \
                            self.type.value + "." + "index"
        data.persistable[Modules.INDEX.value]["runnables"]\
                        [self.type.value] = frozenset([persist])

    def prepare(self, data: Data):
        """
        Prepares the NDVI data space.

        Args:
            data: the pipeline data object
        """
        super().prepare(data)
        data.modules[Modules.INDEX.value]["runnables"][self.type.value] = {}
        # TODO: fix
        self.to_persist(data)
        
    def upload(self, data: Data, collection, bucket, base_url: str):
        pass
