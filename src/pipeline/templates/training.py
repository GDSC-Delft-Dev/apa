from ..pipeline import Pipeline
from ..config import Config
from ..modules.preprocess import AgricultureVisionPreprocess
from ..modules.mosaicing import Mosaicing
import cv2
import glob

def training_pipline() -> Pipeline:
    # Get the masks
    masks = [cv2.imread(file) for file in glob.glob("../test/data/mosaicing/farm/mask*.JPG")]

    # Run the pipeline
    cfg = Config(modules={AgricultureVisionPreprocess: masks, Mosaicing: None})
    return Pipeline(cfg)