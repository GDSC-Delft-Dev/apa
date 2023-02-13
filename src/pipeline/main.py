from pipeline import Pipeline
import glob
import cv2
from templates import full_pipeline

def main():
    # Get test data
    imgs = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/D*.jpg")]
    print(imgs)
    
    # Run the pipeline
    pipeline = full_pipeline()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()