import glob
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat
import firebase_admin
from firebase_admin import credentials

def main():
    """Main entry point."""

    # authenticate to firebase
    cred = credentials.Certificate("terrafarm-378218-firebase-adminsdk-58xzn-50ab6489a8.json")
    firebase_admin.initialize_app(cred)
    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
    imgs = imgs[:1]

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
