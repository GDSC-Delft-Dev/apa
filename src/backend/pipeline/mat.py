from __future__ import annotations
from enum import Enum
import cv2
import numpy as np

class Channels(Enum):
    """Defines channel types for the input images"""
    R = "Red"
    G = "Green"
    B = "Blue"
    RE = "Red Edge"
    NIR = "Near Infrared"
    MIR = "Mid Infrared"
    T = "Thermal"
    GREYSCALE = "Grayscale"

default_channels = [Channels.R, Channels.G, Channels.B]

class Mat():
    """
    Multispectral cv2.Mat with channel naming support.
    """

    def __init__(self, arr: np.ndarray, channels: list[Channels] | None = None):
        """
        Initializes the mat.

        Args:
            arr: the image array
            channels: list of channels in the image array
        """

        self.arr = arr
        self.channels: list[Channels] = default_channels if channels is None else channels

    @classmethod
    def read(cls, path: str) -> Mat:
        """
        Reads an RGB image from the specified path.

        Args:
            path: the path to read the image from
        
        Returns:
            The loaded RGB Mat.
        """

        mat = cv2.imread(path)
        return cls(mat, channels = default_channels)

    @classmethod
    def fread(cls, paths: list[tuple[str, list[Channels]]]) -> Mat:
        """
        UNTESTED. Full reads an image with an arbitrary number of
        channels from multiple source paths.

        Args:
            paths: a dictionary of paths and their corresponding channels
                (in the order they appear in the saved image)
        
        Returns:
            The loaded Mat.
        """

        # Load the images
        mats = [cv2.imread(path[0], cv2.IMREAD_UNCHANGED) if len(path[1]) == 1
                else cv2.imread(path[0])
                for path in paths]

        # Verify input data integrity
        assert len(mats) == len(paths), "Reading images failed"
        shape = mats[0].shape[:2]
        for mat, channels in zip(mats, [path[1] for path in paths]): #type: tuple[cv2.Mat, list[Channels]]
            # Check number of channels
            if len(channels) == 1:
                assert mat.ndim == 2, "Image is not grayscale"
            else:
                assert len(channels) == mat.shape[2], "Image has incorrect number of channels"

            # Check image dimensions
            assert shape == mat.shape[:2]

        # Combine arrays
        # Split multichannel mats
        mats = np.array([mat if mat.ndim == 2 else np.split(mat) for mat in mats])

        # Concatenate grayscales
        arr = np.transpose(mats, (1, 2, 0))

        # Aggregate channels
        channels = sum([path[1] for path in paths], [])

        # Return the combined data
        return cls(arr, channels)

    def get(self) -> cv2.Mat:
        """
        Provides a view of the underlying image array.

        Returns:
            A view of the underlying image array.
        """

        return self.arr.view()

    def make(self, arr: cv2.Mat) -> Mat:
        """
        Makes a copy of this wrapper with a new image array.

        Args:
            arr: the new image array

        Returns:
            A copy of this wrapper with the new image array.
        """

        return Mat(arr, channels=self.channels)

    def __getitem__(self, key: Channels | list[Channels]) -> Mat:
        """
        Provides the specified channels of the mat.
        
        Args:
            key: channel or list of channels to return

        Returns:
            Mat with the specified channels.
        """

        # Make sure the input is an array
        if not isinstance(key, list):
            key = [key]

        # Get data
        arr = self.arr[:,:,[self.channels.index(channel) for channel in key]]

        # Otherwise, return the new mat
        return Mat(arr, channels=key)
