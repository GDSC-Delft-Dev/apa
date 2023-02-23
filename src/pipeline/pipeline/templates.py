from .pipeline import Pipeline
from .config import Config
from .modules.index.index import Index
from .modules.mosaicing import Mosaicing
from .modules.preprocess import AgricultureVisionPreprocess
from .modules.mosaicing import Mosaicing
from .modules.segmentation import SemanticSegmentation
import cv2
import glob

def full_pipeline() -> Pipeline:

    # paths to the saved models
    paths = {3:"./pipeline/ml/deepv3_seg_3/", 4:"./pipeline/ml/deepv3_seg_4/"}

    # Run the pipeline
    cfg = Config(modules={Mosaicing: None, AgricultureVisionPreprocess: None, SemanticSegmentation: paths})
    return Pipeline(cfg)

def training_pipeline() -> Pipeline:
    # Get the masks
    masks = [cv2.imread(file) for file in glob.glob("./pipeline/test/data/mosaicing/farm/mask*.JPG")]
    # Run the pipeline
    cfg = Config(modules={AgricultureVisionPreprocess: masks, Mosaicing: None})
    return Pipeline(cfg)
