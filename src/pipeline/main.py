from pipeline import Pipeline
import glob
import cv2
from config import Config
from modules.mosaicing import Mosaicing

def main():
    # Get test data
    imgs = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/*.jpg")]
    
    # Run the pipeline
    cfg = Config(modules=[Mosaicing])
    pipeline = Pipeline(cfg)
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()