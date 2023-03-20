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

        re = np.asarray(img[Channels.RE].get(), dtype=np.float64)
        red = np.asarray(img[Channels.R].get(), dtype=np.float64)
        green = np.asarray(img[Channels.G].get(), dtype=np.float64)
        
        return 3 *                   \
                ((re - red) - 0.2) * \
                (re - green) *       \
                np.divide(re, red,
                      out=np.zeros_like(re),
                      where=red!=0,
                      casting="unsafe")
