from pipeline import Pipeline
from config import Config
from modules.index.index import Index
from modules.mosaicing import Mosaicing
from modules.preprocess import AgricultureVisionPreprocess
from modules.mosaicing import Mosaicing
import cv2
import glob

def full_pipeline() -> Pipeline:
    # Run the pipeline
    cfg = Config(modules={Mosaicing: None, Index: None})
    return Pipeline(cfg)

def training_pipeline() -> Pipeline:
    # Get the masks
    masks = [cv2.imread(file) for file in glob.glob("../test/data/mosaicing/farm/mask*.JPG")]
    # Run the pipeline
    cfg = Config(modules={AgricultureVisionPreprocess: masks, Mosaicing: None})
    return Pipeline(cfg)