from __future__ import annotations
from enum import Enum
import cv2
import numpy as np

"""
Defines channel types for the input images
"""
class Channels(Enum):
    R = 0,
    G = 1,
    B = 2,
    NIR = 3,
    FIR = 4,
    T = 5

default_channels: dict[Channels, int] = {
    Channels.R: 0,
    Channels.G: 1,
    Channels.B: 2,
    Channels.NIR: 3,
    Channels.FIR: 4,
    Channels.T: 5
}

"""
Multispectral cv2.Mat with channel naming support.
"""
class Mat(cv2.Mat):
    """
    Initializes the mat.

    Args:
        
    """
    def __init__(self, shape, channels: dict[Channels, int] = default_channels):
        super.__init__(shape)
        self.channels = channels
    
    """
    Provides the specified channels of the mat.
    
    Args:
        key: channel or list of channels to return

    Returns:
        Ndarray of the specified channels.
    """
    def __getitem__(self, key: Channels | list[Channels]):
        return self[:, :, self.channels[key]]
