from ...modules.mosaicing import Mosaicing
from ...modules.segmentation import SemanticSegmentation
from ...modules.index.index import Index
from ...modules.preprocess import AgricultureVisionPreprocess
from ...pipeline import Pipeline
from ...mat import Mat, Channels
from ...modules.modules import Modules
from ...config import Config, CloudConfig
from ...modules.index.indicies import Indicies
from ...modules.index.runnables.tcari import TCARI
import glob
import numpy as np
import pytest

class TestNutrientRunnable:
    """
    Unit testing for the nutrient deficiency module.
    """

    @pytest.mark.asyncio
    @pytest.mark.skip(reason="Need the .npy file on Cloud Storage")
    async def test_nutrient(self):
        """
        Test the method run.   
        """  
        paths = {3:"../../ml/deepv3_seg_3/", 4:"../../ml/deepv3_seg_4/"}
        cfg = Config(modules={Mosaicing: None, AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths, Index: None}, 
                     cloud=CloudConfig())
        pipeline = Pipeline(cfg)
        imgs = [Mat.read(file) for file in glob.glob("../data/mosaicing/farm/D*.JPG")]
        result = pipeline.run(imgs)
        assert result.modules[Modules.INDEX]["runnables"][Indicies.NUTRIENT]["index"] is not None
        assert result.modules[Modules.INDEX]["runnables"][Indicies.NUTRIENT]["masks"] is not None
        expected = np.load("nutrient_masks.npy", allow_pickle=True) 
        out = result.modules[Modules.INDEX]["runnables"][Indicies.NUTRIENT]["masks"] 
        assert np.array_equal(out, expected)

    @pytest.mark.asyncio
    async def test_tcari_fail(self):
        # Initialize the pipeline
        cfg = Config(modules={Index: {"config": None, "runnables": [TCARI]}}, 
                     cloud=CloudConfig())
        pipeline = Pipeline(cfg)

        # Read the input images and run the pipeline
        with pytest.raises(AssertionError):
            img = Mat.freads(glob.glob("../data/mosaicing/multispectral/R*.TIF"),
                            [Channels.R, Channels.RE])
            await pipeline.run(img)