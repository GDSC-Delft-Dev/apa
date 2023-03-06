# pylint: disable=E1102
import cv2
import glob
from .pipeline import Pipeline
from .config import Config
from .modules.index.index import Index
from .modules.mosaicing import Mosaicing
from .modules.preprocess import AgricultureVisionPreprocess
from .modules.segmentation import SemanticSegmentation
from .modules.index.runnables.nutrient import Nutrient

def default_pipeline() -> Pipeline:
    """Default pipeline."""
    cfg = Config(modules={Mosaicing: None, Index: None})
    return Pipeline(cfg)

def full_pipeline() -> Pipeline:
    """Full pipeline with inference."""

    # paths to the saved models
    paths = {3:"./pipeline/ml/deepv3_seg_3/", 4:"./pipeline/ml/deepv3_seg_4/"}

    # Run the pipeline
    cfg = Config(modules={Mosaicing: None, AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths})
    return Pipeline(cfg)

def training_pipeline() -> Pipeline:
    """Model training pipeline."""

    # Get the masks
    masks = [cv2.imread(file) for file in glob.glob("../test/data/mosaicing/farm/mask*.JPG")]
    # Run the pipeline
    cfg = Config(modules={AgricultureVisionPreprocess: masks, Mosaicing: None})
    return Pipeline(cfg)


def nutrient_pipeline() -> Pipeline:
    """Nutrient deficiency pipeline."""
    paths = {3:"./pipeline/ml/deepv3_seg_3/", 4:"./pipeline/ml/deepv3_seg_4/"}
    parallel_modules = {Index: ([Nutrient], None)}
    cfg = Config(modules={Mosaicing: None, AgricultureVisionPreprocess: None,
                          SemanticSegmentation: paths}, 
                parallel_modules=parallel_modules)
    return Pipeline(cfg)
