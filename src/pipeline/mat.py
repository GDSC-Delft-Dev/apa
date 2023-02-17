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

default_channels = [Channels.R, Channels.G, Channels.B]

"""
Multispectral cv2.Mat with channel naming support.
"""
class Mat(cv2.Mat):
    """
    Initializes the mat.

    Args:
        shape: the shape of the mat (height, width, channels)
        data: 
    """
    def __init__(self, shape, data: np.ndarray, channels: list[Channels] = default_channels):
        # Initialize the cv2.Mat
        super.__init__(shape)
        self[:,:,:] = data

        # Add channel data
        self.channels: list[Channels] = channels

    """
    Reads an RGB image from the specified path.

    Args:
        path: the path to read the image from
    
    Returns:
        The loaded RGB Mat.
    """
    @classmethod
    def read(cls, path: str) -> Mat:
        mat = cv2.imread(path)
        return cls(mat.shape, np.asarray(mat[:,:]))

    """
    Full reads an image with an arbitrary number of channels from multiple
    source paths.

    Args:
        paths: a dictionary of paths and their corresponding channels
               (in the order they appear in the saved image)
    
    Returns:
        The loaded Mat.
    """
    @classmethod
    def fread(cls, paths: dict[str, list[Channels]]) -> Mat:
        # Load the images
        mats = [cv2.imread(path) for path in paths.keys()]
        
        # Verify that the number of channels match and the
        # dimensions match
        shape = mats[0].shape[:2]
        for mat, channels in zip(mats, dict.values()):
            assert(mat.ndim == len(channels))
            assert(shape == mat.shape[:2])

        # Flatten channels
        channels=sum(paths.values(), [])

        # Combine arrays
        data = np.concatenate([np.asarray(mat[:,:]) for mat in mats], axis=0)
        shape.append(len(channels))

        # Return the combined data
        return cls(shape, data, channels=channels)
    
    """
    Provides the specified channels of the mat.
    
    Args:
        key: channel or list of channels to return

    Returns:
        Ndarray of the specified channels.
    """
    def __getitem__(self, key: Channels | list[Channels]) -> Mat:
        # Make sure the input is an array
        if key is not list:
            key = [key]

        # Make the shape
        shape = self.shape
        shape[2] = len(key)

        # Get data
        data = np.concatenate([np.asarray(self[:,:,self.channels.index(channel)]) for channel in key])

        # Return the new mat
        return Mat(shape, data, channels=key)

