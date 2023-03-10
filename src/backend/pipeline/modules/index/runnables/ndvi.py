from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from ....mat import Channels
import numpy as np
import cv2
import matplotlib.pyplot as plt

class NDVI(Runnable):
    """
    The Normalized Differential Vegetation Index runnable.
    https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index
    """

    def __init__(self, data: Data):
        super().__init__(data, name="NDVI", channels=[Channels.NIR, Channels.R])
        self.type = Indicies.NDVI

    def run(self, data: Data) -> bool:
        """
        Computes the NDVI map on the processed image. The values inare saved
        in the runnable's index field. 

        range - (-1.0, 1.0); 
        Use plt.imshow(ndvi, cmap='RdYlGn', vmin=-1.0, vmax=1.0) to preview.
        
        Args:
            data: the pipeline data object with the stitched images

        Returns:
            Whether the execution was successful.
        """
        try:
            # Get the channels
            nir = data.modules[Modules.MOSAIC.value]["stitched"][Channels.NIR].get()
            red = data.modules[Modules.MOSAIC.value]["stitched"][Channels.R].get()

            # Calculate 
            ndvi = self.calculate(nir, red)
            data.modules[Modules.INDEX.value]["runnables"][self.type.value]["index"] = ndvi
            plt.imshow(ndvi, cmap='RdYlGn', vmin=-1.0, vmax=1.0)
            plt.show()
            return True

        # Catch exception
        except Exception as exception:
            print("NDVI calculation failed!")
            print(exception)
            return False

    def calculate(self, nir, red) -> np.ndarray:
        """
        Calulcates the NDVI index.

        Args:
            nir: the near-infrared spectrum
            red: the red band

        Returns:
            The NDVI index.
        """

        numerator = np.asarray(nir - red, dtype=np.float64)
        denominator = np.asarray(nir + red, dtype=np.float64)
        return np.divide(numerator, denominator,
                         out=np.zeros_like(numerator),
                         where=denominator!=0,
                         casting="unsafe")

    def to_persist(self, data: Data):
        persist: str = Modules.INDEX.value + "." + "runnables" + "." + \
                            self.type.value + "." + "index"
        data.persistable[Modules.INDEX.value]["runnables"][self.type.value] = frozenset([persist])

    def prepare(self, data: Data):
        """
        Prepares the NDVI data space.

        Args:
            data: the pipeline data object
        """
        super().prepare(data)
        self.to_persist(data)
        data.modules[Modules.INDEX.value]["runnables"][self.type.value] = frozenset()

    def upload(self, data: Data, collection, bucket, base_url: str):
        pass
