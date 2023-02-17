from pipeline import Pipeline
import glob
import cv2
from templates import full_pipeline
from modules.mosaicing import Mosaicing
from mat import Mat, Channels

def main():
    # Get test data
    imgs = [cv2.imread(file) for file in glob.glob("test/data/mosaicing/farm/D*.jpg")]

    mat = Mat.read("test/data/mosaicing/farm/DJI_0081-min.JPG")
    red = mat[[Channels.R]]
    cv2.imshow("red", red.get())
    cv2.waitKey()
    cv2.destroyAllWindows()

    # Run the pipeline
    pipeline = full_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()