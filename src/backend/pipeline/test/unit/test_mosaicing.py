from ...modules.preprocess import Preprocess
from ...modules.data import Data
from ...mat import Mat
from ...modules.modules import Modules
from ...config import Config
from ...modules.mosaicing import Mosaicing
from ...pipeline import Pipeline
import glob
import cv2
import numpy as np
import pytest

class TestMosaicingModule:
    """
    Unit testing for the preprocessing module.
    """

    def test_alpha_mosaicing(self):
        """
        Test the mask created by the mosaicing module
        used to highlight the black borders.   
        """  
        cfg = Config(modules={Mosaicing: None})
        pipeline = Pipeline(cfg)
        imgs = [Mat.read(file) for file in glob.glob("../data/mosaicing/farm/D*.JPG")]
        # run the pipeline with the Mosaicing module
        result = pipeline.run(imgs)
        assert result.modules[Modules.MOSAIC]["mask"] is not None
        assert result.modules[Modules.MOSAIC]["alpha_img"] is not None

        stitched = result.modules[Modules.MOSAIC]["stitched"]
        collapsed = np.sum(stitched.get(), axis=2)
        mask = np.where(collapsed == 0.0, 1, 0)
        mask = np.expand_dims(mask, 2)
        assert np.array_equal(np.where(mask == 1, 0, 1), result.modules[Modules.MOSAIC]["mask"])

    def test_mosaicing(self):
        """
        Test the method run of the mosaic module.
        """
        cfg = Config(modules={Mosaicing: None})
        pipeline = Pipeline(cfg)
        imgs = [Mat.read(file) for file in glob.glob("../data/mosaicing/farm/D*.JPG")]
        # run the pipeline
        result = pipeline.run(imgs)
        imgs_shape = [mat.get().shape for mat in imgs]
        # add up all the shapes
        sumx = [0, 0]
        for s in imgs_shape:
            sumx[0] += s[0]
            sumx[1] += s[1]
        stitched_shape = result.modules[Modules.MOSAIC]["stitched"].get().shape
        assert stitched_shape[0] <= sumx[0]
        assert stitched_shape[1] <= sumx[1]
        # only have RGB channels
        assert stitched_shape[2] == 3
