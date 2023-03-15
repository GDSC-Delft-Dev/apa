from ...data import Data
from ..indicies import Indicies
from ....mat import Mat, Channels
import numpy as np
from generic import GenericIndex

class NDVI(GenericIndex):
    """
    The Normalized Differential Vegetation Index runnable.
    https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index
    """

    def __init__(self, data: Data):
        super().__init__(data, name="NDVI", color_map="RdYlGn",
                         channels=[Channels.NIR, Channels.R], type=Indicies.NDVI)

    def calculate(self, img: Mat) -> np.ndarray:
        nir, red = img[Channels.NIR, Channels.R]
        numerator = np.asarray(nir - red, dtype=np.float64)
        denominator = np.asarray(nir + red, dtype=np.float64)
        return np.divide(numerator, denominator,
                         out=np.zeros_like(numerator),
                         where=denominator!=0,
                         casting="unsafe")