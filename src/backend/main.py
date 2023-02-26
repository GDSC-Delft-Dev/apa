import glob
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat

def main():
    """Main entry point."""

    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
