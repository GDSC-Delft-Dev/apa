# pylint: disable=E1102
import cv2
import glob
from .pipeline import Pipeline
from .config import Config, CloudConfig
from .modules.mosaicing import Mosaicing
from .modules.preprocess import AgricultureVisionPreprocess
from .modules.segmentation import SemanticSegmentation
from .modules.index.runnables.nutrient import Nutrient
from .modules.index.runnables.ndvi import NDVI
from .modules.index.index import Index

def default_pipeline(cloud: CloudConfig = CloudConfig()) -> Pipeline:
    """Default pipeline."""
    cfg = Config(modules={Mosaicing: None, Index: None},
                cloud=cloud)
    return Pipeline(cfg)

def full_pipeline() -> Pipeline:
    """Full pipeline with inference."""

    # paths to the saved models
    paths = {3:"./pipeline/ml/deepv3_seg_3/", 4:"./pipeline/ml/deepv3_seg_4/"}

    # Run the pipeline
    cfg = Config(modules={Mosaicing: None, 
                          AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths},
                cloud=CloudConfig(True, "terrafarm-example"))
    return Pipeline(cfg)

def training_pipeline() -> Pipeline:
    """Model training pipeline."""

    # Get the masks
    masks = [cv2.imread(file) for file in sorted(glob.glob("../test/data/mosaicing/farm/mask*.JPG"))]
    # Run the pipeline
    cfg = Config(modules={AgricultureVisionPreprocess: masks, 
                          Mosaicing: None}, 
                 cloud=CloudConfig(True, "terrafarm-example"))
    return Pipeline(cfg)

def nutrient_pipeline() -> Pipeline:
    """Nutrient deficiency pipeline."""
    paths = {3:"./pipeline/ml/deepv3_seg_3/", 4:"./pipeline/ml/deepv3_seg_4/"}
    cfg = Config(modules={Mosaicing: None,
                          AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths,
                          Index: {"config": None, "runnables": [Nutrient]}},
                cloud=CloudConfig(False, "terrafarm-example"))
    return Pipeline(cfg)
