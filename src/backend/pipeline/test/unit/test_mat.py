from ...mat import Mat, Channels
import cv2
import numpy as np
import os
import glob
import pytest

class TestMat:
    """
    Unit testing for the Mat class.
    """
    def test_read(self):
        """Test the read class method."""

        path = "../data/segmentation/1AD76MIZN_659-8394-1171-8906.jpg"
        mat = cv2.imread(path)
        assert mat is not None, "The image could not be read"

        # create a Mat object with an image from the specified path
        obj = Mat.read(path)
        expected = Mat(mat)
        assert np.array_equal(obj.arr, expected.arr), "The images are different"
        assert obj.channels == expected.channels, "The number of channels are different"

    def test_get(self):
        """Test the get method."""
        path = "../data/segmentation/1AD76MIZN_659-8394-1171-8906.jpg"
        arr = cv2.imread(path)
        obj = Mat(arr)
        assert np.array_equal(arr, obj.get())

    def test_fread_grayscales(self):
        """Tests the fread method with grayscale images only."""
        paths = glob.glob(f"../data/mosaicing/multispectral/*.TIF")
        img = Mat.freads(paths, [Channels.G, Channels.NIR, Channels.RE, Channels.R])

        assert len(img.channels) == 4, "The number of channels is incorrect"

    def test_fread_missing_channel(self):
        """Tests the fread method with a missing channel."""
        paths = glob.glob(f"../data/mosaicing/multispectral/*.TIF")

        with pytest.raises(AssertionError):
            Mat.freads(paths, [Channels.G, Channels.RE, Channels.R])
