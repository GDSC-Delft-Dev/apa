import glob
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat, Channels
import os
import numpy as np

def main():
    """Main entry point."""

    # Get test data
    paths = np.array([glob.glob(f"pipeline/test/data/mosaicing/multispectral/*_{channel}.tif") for channel in range(1, 4)]).T
    imgs = [Mat.fread([(path[0], [Channels.R]), (path[1], [Channels.B]), (path[2], [Channels.R])]) for path in paths]

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()

    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
