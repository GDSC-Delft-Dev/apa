from ..pipeline import Pipeline
from ..config import Config
from ..modules.index.index import Index
from ..modules.mosaicing import Mosaicing

def full_pipeline() -> Pipeline:
    # Run the pipeline
    cfg = Config(modules={Mosaicing: None, Index: None})
    return Pipeline(cfg)