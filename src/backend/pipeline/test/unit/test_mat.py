from ...mat import Mat
import cv2
import numpy as np
import os

class TestMat:
    """
    Unit testing for the Mat class.
    """

    def test_read(self):
        """
        Test the read class method.
        """
        path = "./test/data/segmentation/1AD76MIZN_659-8394-1171-8906.jpg"
        # create a Mat object with an image from the specified path
        obj = Mat.read(path)
        expected = Mat(cv2.imread(path))
        assert np.array_equal(obj.arr, expected.arr)
        assert obj.channels == expected.channels

    def test_get(self):
        """
        Test the get method.
        """
        path = "./test/data/segmentation/1AD76MIZN_659-8394-1171-8906.jpg"
        arr = cv2.imread(path)
        obj = Mat(arr)
        assert np.array_equal(arr, obj.get())
