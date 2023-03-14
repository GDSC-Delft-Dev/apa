import glob
import sys
import os
import argparse
from pipeline.mat import Mat
from google.cloud import storage
from pipeline.templates import full_pipeline, default_pipeline, training_pipeline, nutrient_pipeline
import asyncio
from pipeline.config import CloudConfig
from typing import Any
from pipeline.auth import init_firebase

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
            open(filename, 'a', 'utf-8').close()
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Runs the pipeline')
    parser.add_argument('--path', dest='path', default=None)
    parser.add_argument('--mode', dest='mode', default=None)    
    main(parser.parse_args(sys.argv[1:]))
