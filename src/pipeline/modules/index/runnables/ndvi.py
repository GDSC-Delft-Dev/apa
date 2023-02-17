from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from mat import Channels
import numpy as np

"""
The Normalized Differential Vegetation Index runnable.
https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index
"""
class NDVI(Runnable):
    def __init__(self, data: Data):
        super().__init__("NDVI", data)
        self.type = Indicies.NDVI

    """
    Computes the NDVI map on the processed image. The values inare saved
    in the runnable's index field. 

    range - (-1.0, 1.0); Uue the RdYlGn cmap to display.
    
    Args:
        data: the pipeline data object with the stitched images

    Returns:
        Whether the execution was successful.
    """
    def run(self, data: Data) -> bool:
        try:
            # Get the channels
            nir = data.modules[Modules.MOSAIC]["stitched"][Channels.NIR].get()
            red = data.modules[Modules.MOSAIC]["stitched"][Channels.R].get()

            # Calculate 
            ndvi = self.calculate(nir, red)
            data.modules[Modules.INDEX]["runnables"][self.type]["index"] = ndvi
            return True

        # Catch exception
        except Exception as e:
            print("NDVI calculation failed!")
            print(e)
            return False

    """
    Calulcates the NDVI index.

    Args:
        nir: the near-infrared spectrum
        red: the red band

    Returns:
        The NDVI index.
    """
    def calculate(self, nir, red) -> np.ndarray:
        a = np.asarray(nir - red, dtype=np.float64)
        b = np.asarray(nir + red, dtype=np.float64)
        return np.divide(a, b, out=np.zeros_like(a), where=b!=0, casting="unsafe")

    """
    Prepares the NDVI data space.

    Args:
        data: the pipeline data object
    """
    def prepare(self, data: Data):
        super().prepare(data)
        data.modules[Modules.INDEX]["runnables"][self.type] = {}