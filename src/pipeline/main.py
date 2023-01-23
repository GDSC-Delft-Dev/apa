from pipeline import Pipeline
import glob
import cv2
import numpy as np

IMAGE_WIDTH = 5472
IMAGE_HEIGHT = 3078
CHANNELS = 3

def main():
    # Get test data
    img = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/D*.JPG")]
    masks = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/mask*.JPG")]
    # Run the pipeline
    pipeline = Pipeline()
    pipeline.run(img, masks)

if __name__ == "__main__":
    main()