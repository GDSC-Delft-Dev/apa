from pipeline import Pipeline
import glob
import cv2
from config import Config
from modules.mosaicing import Mosaicing
from templates.full import training_pipline

def main():
    # Get test data
    imgs = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/D*.JPG")]
    masks = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/mask*.JPG")]
    
    # Run the pipeline
    pipeline = training_pipline()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()