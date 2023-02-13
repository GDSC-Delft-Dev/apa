from ..pipeline import Pipeline
from ..config import Config
from ..modules.preprocess import AgricultureVisionPreprocess
from ..modules.mosaicing import Mosaicing

def training_pipline() -> Pipeline:
    # Run the pipeline
    cfg = Config(modules=[AgricultureVisionPreprocess, Mosaicing])
    return Pipeline(cfg)