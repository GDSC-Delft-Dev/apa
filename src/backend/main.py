import glob
from pipeline.templates import full_pipeline, default_pipeline, training_pipeline, nutrient_pipeline
import firebase_admin
from firebase_admin import credentials, firestore
import asyncio
import datetime
from pipeline.mat import Mat, Channels
import os
import numpy as np

def main():
    """Main entry point."""

    # authenticate to firebase
    cred = credentials.Certificate("terrafarm-378218-firebase-adminsdk-nept9-e49d1713c7.json")
    firebase_admin.initialize_app(cred)
    # Get test data
    imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
    imgs = imgs[:1]

    # Run the pipeline
    pipeline = nutrient_pipeline()
    pipeline.show()
    res = asyncio.run(pipeline.run(imgs))
    # Print the result
    print(res)

if __name__ == "__main__":
    main()
