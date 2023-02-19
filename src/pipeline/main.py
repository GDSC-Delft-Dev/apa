from pipeline import Pipeline
import glob
import cv2
from templates import full_pipeline
from modules.mosaicing import Mosaicing
from mat import Mat, Channels

def main():
    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("test/data/mosaicing/farm/D*.JPG")]
    # Run the pipeline
    pipeline = full_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
