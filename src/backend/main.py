import glob
from pipeline.templates import full_pipeline, default_pipeline, training_pipeline, nutrient_pipeline
import firebase_admin
from firebase_admin import credentials, firestore
import asyncio
from pipeline.mat import Mat, Channels
import numpy as np

def main():
    """Main entry point."""

    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
    imgs = imgs[:3]

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()

    # Authenticate to firebase
    if pipeline.config.cloud.use_cloud:
        cred = credentials.Certificate("terrafarm-378218-firebase-adminsdk-nept9-e49d1713c7.json")
        firebase_admin.initialize_app(cred)

    # Run the pipeline
    res = asyncio.run(pipeline.run(imgs))
    print(res)

if __name__ == "__main__":
    main()
