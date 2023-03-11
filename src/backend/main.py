import glob
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat
import firebase_admin
from firebase_admin import credentials, firestore
import asyncio
import datetime

def main():
    """Main entry point."""

    # authenticate to firebase
    cred = credentials.Certificate("terrafarm-378218-firebase-adminsdk-nept9-e49d1713c7.json")
    firebase_admin.initialize_app(cred)
    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
    imgs = imgs[:1]

    # Run the pipeline
    pipeline = full_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)
    # Print the result
    print(res)

if __name__ == "__main__":
    main()
