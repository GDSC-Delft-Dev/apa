from ...modules.preprocess import Preprocess
from ...modules.data import Data
from ...mat import Mat
from ...modules.modules import Modules
import glob
import cv2
import uuid
import numpy as np
import os
from google.cloud import storage

class TestPreprocessingModule:
    """
    Unit testing for the preprocessing module.
    """

    

    def test_preprocessing(self):
        """
        Test the method run.   
        """  
        masks = [cv2.imread(file) for file in glob.glob("../data/mosaicing/farm/mask*.JPG")]
        imgs = [Mat.read(file) for file in glob.glob("../data/mosaicing/farm/D*.JPG")]
        data: Data = Data(uuid.uuid4())
        data.modules[Modules.PREPROCESS.value] = {}
        module = Preprocess(data, masks)
        data.set(imgs)
        module.run(data)
        assert data.modules[Modules.PREPROCESS.value]["masked"] is not None
        out = np.array([x.get() for x in data.modules[Modules.PREPROCESS.value]["masked"]])
        # connect to Cloud Storage
        storage_client = storage.Client()
        bucket = storage_client.bucket("terrafarm-test")
        blob = bucket.blob("expected_preprocess_masked.npy")
        blob.download_to_filename("expected_preprocess_masked.npy")
        expected = np.load("expected_preprocess_masked.npy", allow_pickle=True) 
        assert np.array_equal(out, expected)
        os.remove("expected_preprocess_masked.npy") 
