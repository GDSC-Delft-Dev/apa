from ...modules.mosaicing import Mosaicing
from ...modules.segmentation import SemanticSegmentation
from ...modules.index.index import Index
from ...modules.preprocess import AgricultureVisionPreprocess
from ...pipeline import Pipeline
from ...mat import Mat
from ...modules.modules import Modules
from ...config import Config, CloudConfig
from ...modules.index.indicies import Indicies
from ...modules.index.runnables.nutrient import Nutrient
from ...auth import get_credentials
from google.cloud import storage
import os
import glob
import numpy as np
import pytest
import asyncio

class TestNutrientRunnable:
    """
    Unit testing for the nutrient deficiency module.
    """

    @pytest.mark.asyncio
    async def test_nutrient(self):
        """
        Test the method run.   
        """  
        paths = {3:"../../ml/deepv3_seg_3/", 4:"../../ml/deepv3_seg_4/"}
        # initialize config for the pipeline with the necessary modules
        cfg = Config(modules={Mosaicing: None, AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths, Index: {"config": None, "runnables": [Nutrient]}}, 
                     cloud=CloudConfig())
        pipeline = Pipeline(cfg)
        # get image paths
        imgs = [Mat.read(file) for file in sorted(glob.glob("../data/mosaicing/farm/D*.JPG"))]
        # run the pipeline
        result = await pipeline.run(imgs)
        assert result.modules[Modules.INDEX.value]["runnables"][Indicies.NUTRIENT.value]["index"] is not None
        assert result.modules[Modules.INDEX.value]["runnables"][Indicies.NUTRIENT.value]["masks"] is not None

        # if the necessary data is not already stored locally, download it from the cloud
        if not os.path.exists("nutrient_masks.npy"):
            # connect to Cloud Storage
            storage_client = storage.Client(credentials=get_credentials())
            bucket = storage_client.bucket("terrafarm-test")
            blob = bucket.blob("nutrient_masks.npy")
            blob.download_to_filename("nutrient_masks.npy")

        # load data and assert
        expected = np.load("nutrient_masks.npy", allow_pickle=True) 
        out = result.modules[Modules.INDEX.value]["runnables"][Indicies.NUTRIENT.value]["masks"] 
        assert np.array_equal(out, expected)
