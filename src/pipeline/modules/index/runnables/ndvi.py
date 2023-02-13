from ...runnable import Runnable
from ...data import Data, Modules
from ..indicies import Indicies
from mat import Channels

class NDVI(Runnable):
    def __init__(self, data: Data):
        super().__init__("NDVI")
        self.type = Indicies.NDVI
        data.modules[Modules.INDEX]["indicies"][self.type] = {}

    """
    Computes the NDVI map on the processed image.
    """
    def run(self, data: Data) -> bool:
        try:
            nir, red = data.input[[Channels.NIR, Channels.R]]
            ndvi = (nir - red) / (nir + red)
            data.modules[Modules.INDEX].indicies[self.type]["index"] = ndvi
            return True
        except:
            print("NDVI calculation failed")
            return False

    """
    Prepares the NDVI data space.
    """
    def prepare(self, data: Data):
        super().prepare(data)