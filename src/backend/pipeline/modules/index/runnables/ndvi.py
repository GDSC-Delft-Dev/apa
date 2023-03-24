from ...data import Data
from ..indicies import Indicies
from ....mat import Mat, Channels
import numpy as np
from .generic import GenericIndex

class NDVI(GenericIndex):
    """
    The Normalized Differential Vegetation Index runnable.
    https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index
    """

    def __init__(self, data: Data):
        """
        Initializes the NDVI runnable.

        Args:
            data: the pipeline data object
        """
        super().__init__(data, name="NDVI", color_map="RdYlGn",
                         channels=[Channels.NIR, Channels.R], index_type=Indicies.NDVI)

    def calculate(self, img: Mat) -> np.ndarray:
        """
        Calulcates the NDVI index.
        
        Args:
            img: the image to calculate the index on
            
        Returns:
            The NDVI index.
        """

        nir = img[Channels.NIR].get()
        red = img[Channels.R].get()

        numerator = np.asarray(nir - red, dtype=np.float64)
        denominator = np.asarray(nir + red, dtype=np.float64)
        return np.divide(numerator, denominator,
                         out=np.zeros_like(numerator),
                         where=denominator!=0,
                         casting="unsafe")
