import glob
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat, Channels
import os
import numpy as np

def main():
    """Main entry point."""

    # Get test data
    paths = glob.glob(f"test/data/mosaicing/multispectral/*.TIF")
    imgs = Mat.fread([(paths[0], [Channels.G]), (paths[1], [Channels.NIR]), (paths[2], [Channels.RE]), (paths[3], [Channels.R])])

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()

    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
