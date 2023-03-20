from ...modules.preprocess import Preprocess
from ...modules.data import Data
from ...mat import Mat
from ...modules.modules import Modules
import glob
import cv2
import uuid
import numpy as np
import os
import pytest

class TestPreprocessingModule:
    """
    Unit testing for the preprocessing module.
    """

    @pytest.mark.asyncio
    def test_preprocessing(self):
        """
        Test the method run.   
        """  
        masks = [cv2.imread(file) for file in sorted(glob.glob("../data/mosaicing/farm/mask*.JPG"))]
        imgs = [Mat.read(file) for file in sorted(glob.glob("../data/mosaicing/farm/D*.JPG"))]
        data: Data = Data(uuid.uuid4())
        data.modules[Modules.PREPROCESS.value] = {}
        module = Preprocess(data, masks)
        data.set(imgs)
        module.run(data)
        assert data.modules[Modules.PREPROCESS.value]["masked"] is not None
        out = np.array([x.get() for x in data.modules[Modules.PREPROCESS.value]["masked"]])

        # Download the expected output from Cloud Storage
        if not os.path.exists("expected_preprocess_masked.npy"):
            pytest.storage_client                           \
                .bucket("terrafarm-test")                   \
                .blob("expected_preprocess_masked.npy")     \
                .download_to_filename("expected_preprocess_masked.npy")
            
        # Load the expected output
        expected = np.load("expected_preprocess_masked.npy", allow_pickle=True) 
        assert np.array_equal(out, expected)
