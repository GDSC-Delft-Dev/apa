from pipeline import Pipeline
import glob
import cv2

def main():
    # Get test data
    img = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/*.jpg")]
    
    # Run the pipeline
    pipeline = Pipeline({})
    pipeline.run(img)

if __name__ == "__main__":
    main()