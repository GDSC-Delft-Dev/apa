from ...modules.preprocess import Preprocess
from ...modules.data import Data
from ...mat import Mat
from ...modules.modules import Modules
import glob
import cv2
import numpy as np

class TestPreprocessingModule:
    """
    Unit testing for the preprocessing module.
    """

    def test_preprocessing(self):
        """
        Test the method run.   
        """  
        masks = [cv2.imread(file) for file in glob.glob("./test/data/mosaicing/farm/mask*.JPG")]
        imgs = [Mat.read(file) for file in glob.glob("test/data/mosaicing/farm/D*.JPG")]
        data: Data = Data()
        data.modules[Modules.PREPROCESS] = {}
        module = Preprocess(data, masks)
        data.set(imgs)
        module.run(data)
        assert data.modules[Modules.PREPROCESS]["masked"] is not None
        out = np.array([x.get() for x in data.modules[Modules.PREPROCESS]["masked"]])
        expected = np.load("expected_preprocess_masked.npy", allow_pickle=True) 
        assert np.array_equal(out, expected)
