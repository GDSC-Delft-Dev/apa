from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from mat import Channels

class NDVI(Runnable):
    def __init__(self, data: Data):
        super().__init__("NDVI", data)
        self.type = Indicies.NDVI

    """
    Computes the NDVI map on the processed image.
    """
    def run(self, data: Data) -> bool:
        try:
            nir, red = data.modules[Modules.MOSAIC]["stitched"][[Channels.NIR, Channels.R]]
            ndvi = (nir - red) / (nir + red)
            data.modules[Modules.INDEX]["runnables"][self.type]["index"] = ndvi
            return True
        except Exception as e:
            print("NDVI calculation failed!")
            print(e)
            return False

    """
    Prepares the NDVI data space.
    """
    def prepare(self, data: Data):
        super().prepare(data)
        data.modules[Modules.INDEX]["runnables"][self.type] = {}