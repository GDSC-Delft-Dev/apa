from ...data import Data
from ..indicies import Indicies
from ....mat import Mat, Channels
import numpy as np
from .generic import GenericIndex

class TCARI(GenericIndex):
    """
    The Transformed Chlorophyll Absorption Ratio Index (TCARI) runnable.
    https://www.l3harrisgeospatial.com/docs/narrowbandgreenness.html
    """

    def __init__(self, data: Data):
        """
        Initializes the NDVI runnable.

        Args:
            data: the pipeline data object
        """
        super().__init__(data, name="TCARI", color_map="RdYlGn",
                         channels=[Channels.RE, Channels.G, Channels.R], 
                         index_type=Indicies.TCARI)

    def calculate(self, img: Mat) -> np.ndarray:
        """
        Calulcates the NDVI index.
        
        Args:
            img: the image to calculate the index on
            
        Returns:
            The NDVI index.
        """

        re = img[Channels.RE].get()
        red = img[Channels.R].get()
        green = img[Channels.G].get()

        a = (re - red) - 0.2
        b = (re - green)
        c_numerator = np.asarray(re, dtype=np.float64)
        c_denominator = np.asarray(red, dtype=np.float64)
        c = np.divide(c_numerator, c_denominator,
                      out=np.zeros_like(c_numerator),
                      where=c_denominator!=0,
                      casting="unsafe")
        
        return 3 * a * b * c
