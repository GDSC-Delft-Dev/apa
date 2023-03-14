import glob
import sys
import os
import argparse
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat
from google.cloud import storage
from pipeline.templates import full_pipeline, default_pipeline, training_pipeline, nutrient_pipeline
import firebase_admin
from firebase_admin import credentials, firestore
import asyncio
from pipeline.mat import Mat, Channels
from pipeline.config import CloudConfig
from pipeline.modules.modules import Modules
import numpy as np
import cv2
from typing import Any
import json
import io

def main(args: Any):
    """Main entry point."""

    # check if we use cloud data or local data
    if args.path is None or args.mode is None:
        imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
        path = "pipeline/test/data/mosaicing/farm/D*.JPG"
        cloud_config = CloudConfig(bucket_name="terrafarm-example")
    else:
        storage_client = storage.Client()
        cloud_config = CloudConfig(
            use_cloud=True,
            input_path=args.path,
            staged_input=(args.mode == "local"),
            bucket_name="terrafarm-example"
        )

        if not os.path.exists("./pipeline/data"):
            os.mkdir("./pipeline/data/")
        if args.mode == "local":
            bucket = storage_client.get_bucket("terrafarm-inputs")
        else:
            bucket = storage_client.get_bucket("terrafarm-test")

        # get all the files from the specified bucket and prefix path
        blobs = bucket.list_blobs(prefix=args.path + "/D", delimiter="/")
        for blob in blobs:
            print(blob)
            print(os.getcwd())
            filename = f"./pipeline/data/{blob.name.split('/')[-1]}"
            open(filename, 'a').close()
            blob.download_to_filename(f"./pipeline/data/{blob.name.split('/')[-1]}")
        
        imgs = [Mat.read(file) for file in glob.glob("pipeline/data/D*.JPG")]

    # Get test data
    imgs = imgs[:4]

    # Run the pipeline
    pipeline = default_pipeline(cloud=cloud_config)
    pipeline.show()

    # Authenticate to firebase
    if pipeline.config.cloud.use_cloud:
        init_firebase()

    # Run the pipeline
    res = asyncio.run(pipeline.run(imgs))
    print(res)

def init_firebase() -> None:
    firebase_admin.initialize_app(
        credentials.Certificate({
            "type": "service_account",
            "project_id": "terrafarm-378218",
            "private_key_id": "e49d1713c7e05e739356fc2f9e0759ca2b9dfb8e",
            "private_key": os.environ['GCP_FA_PRIVATE_KEY'].replace(r'\n', '\n'),
            "client_email": "firebase-adminsdk-nept9@terrafarm-378218.iam.gserviceaccount.com",
            "client_id": "101663378253310814844",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nept9%40terrafarm-378218.iam.gserviceaccount.com"
        })
    )

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Runs the pipeline')
    parser.add_argument('--path', dest='path', default=None)
    parser.add_argument('--mode', dest='mode', default=None)
    args = parser.parse_args(sys.argv[1:])

    main(args)
