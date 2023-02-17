from __future__ import annotations
from enum import IntEnum
import cv2
import numpy as np

"""
Defines channel types for the input images
"""
class Channels(IntEnum):
    R = 0
    G = 1
    B = 2
    NIR = 3
    FIR = 4
    T = 5

default_channels = [Channels.R, Channels.G, Channels.B]

"""
Multispectral cv2.Mat with channel naming support.
"""
class Mat():
    """
    Initializes the mat.

    Args:
        arr: the image array
        channels: list of channels in the image array
    """
    def __init__(self, arr: np.ndarray, channels: list[Channels] = default_channels):
        self.arr = arr
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
        return cls(mat, channels = default_channels)

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
        channels = sum(paths.values(), [])

        # Combine arrays
        arr = np.concatenate([np.asarray(mat[:,:]) for mat in mats], axis=0)
        shape.append(len(channels))

        # Return the combined data
        return cls(shape, data=data, channels=channels)

    """
    Returns the underlying mat.

    Returns:
        The underlying mat
    """
    def get(self) -> cv2.Mat:
        return self.arr
    
    """
    Provides the specified channels of the mat.
    
    Args:
        key: channel or list of channels to return

    Returns:
        Ndarray of the specified channels.
    """
    def __getitem__(self, key: Channels | list[Channels]) -> Mat:
        # Make sure the input is an array
        if not isinstance(key, list):
            key = [key]

        # Get data
        arr = self.arr[:,:,[self.channels.index(channel) for channel in key]]

        # Return the new mat
        return Mat(arr, channels=key)

