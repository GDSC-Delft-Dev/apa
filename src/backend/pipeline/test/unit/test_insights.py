import pytest
from ...pipeline import Pipeline
from ...config import Config, CloudConfig
from ...modules.insights.insight import Insight
from ...modules.insights.diseases.potato import PotatoDiseaseInsight
from ...modules.insights.diseases.tomato import TomatoDiseaseInsight
from ...modules.preprocess import StandardizePreprocess
from ...mat import Mat
import glob

class TestTomatoRunnable:
    """
    Unit test for the TomatoInsight module.
    """

    @pytest.mark.asyncio
    @pytest.mark.skip(reason="Need to change model path.")
    async def test_run(self):
        
        cfg = Config(modules={StandardizePreprocess: None,
                          Insight: {"config": None, "runnables": [TomatoDiseaseInsight]}},
                cloud=CloudConfig(False, "terrafarm-example"))
        pipeline = Pipeline(cfg)
        imgs = [Mat.read(file) for file in glob.glob("../data/disease/*.JPG")]
        result = await pipeline.run(imgs)
        assert True == False
        assert result is not None
        assert result.modules["Insight"]["runnables"] is not None

class TestPotatoRunnable:
    """
    Unit test for the PotatoInsight module.
    """

    @pytest.mark.asyncio
    @pytest.mark.skip(reason="Need to train model.")
    async def test_run(self):
        
        cfg = Config(modules={StandardizePreprocess: None,
                          Insight: {"config": None, "runnables": [PotatoDiseaseInsight]}},
                cloud=CloudConfig(False, "terrafarm-example"))
        pipeline = Pipeline(cfg)
        imgs = [Mat.read(file) for file in glob.glob("../data/disease/*.JPG")]
        result = await pipeline.run(imgs)
        assert True == False
        assert result is not None
        assert result.modules["Insight"]["runnables"] is not None
