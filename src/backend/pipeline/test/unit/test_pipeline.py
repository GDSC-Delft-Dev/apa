from ...mat import Mat
import cv2
import numpy as np
from ...pipeline import Pipeline
from ...config import Config
from ...modules.mosaicing import Mosaicing
from ...modules.index.index import Index
from ...modules.index.runnables.ndvi import NDVI
from ...modules.data import Data
import pytest
import glob

class TestPipeline:
    """Unit testing for the Pipeline class."""

    def test_init_empty(self):
        """Test the create method."""
        
        with pytest.raises(AssertionError):
            config: Config = Config({})
            Pipeline(config)        

    def test_init_module(self):
        """Test the create method with a normal module."""
        
        config: Config = Config({ Mosaicing: None })
        pipeline = Pipeline(config)

        assert isinstance(pipeline.head, Mosaicing)
        assert isinstance(pipeline.data_proto, Data)
        assert pipeline.head.next is None

    def test_init_modules(self):
        """Test the create method with multiple modules."""
        
        config: Config = Config({ Mosaicing: None, 
                                  Index: {"config": None, "runnables": [NDVI] }})
        pipeline = Pipeline(config)

        assert isinstance(pipeline.head, Mosaicing)
        assert isinstance(pipeline.head.next, Index)
        assert pipeline.head.next.next is None

    @pytest.mark.asyncio
    async def test_verify_fail(self):
        """Test the verify method."""

        imgs = [Mat.read(file) for file in glob.glob("../data/mosaicing/farm/D*.JPG")]
        
        config: Config = Config({ Index: {"config": None, "runnables": [NDVI] }})
        pipeline = Pipeline(config)

        with pytest.raises(RuntimeError):
            await pipeline.run(imgs)
