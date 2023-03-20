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
from tqdm import tqdm

# output bucket for pipeline results
output_bucket = "terrafarm-example"
# local input bucket
local_input_bucket = "terrafarm-inputs"
# cloud input bucket
cloud_input_bucket = "terrafarm-test"

def main(args: Any):
    """Main entry point."""

    # check if we use cloud data or local data
    if args.path is None or args.mode is None:
        imgs = [Mat.read(file) for file in sorted(glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG"))]
        path = "pipeline/test/data/mosaicing/farm/D*.JPG"
        cloud_config = CloudConfig(bucket_name=output_bucket)
    else:
        storage_client = storage.Client()
        cloud_config = CloudConfig(
            use_cloud=True,
            input_path=args.path,
            staged_input=(args.mode == "local"),
            bucket_name=output_bucket
        )

        if not os.path.exists("./pipeline/data"):
            os.mkdir("./pipeline/data/")
        if args.mode == "local":
            bucket = storage_client.get_bucket(local_input_bucket)
        else:
            bucket = storage_client.get_bucket(cloud_input_bucket)

        # get all the files from the specified bucket and prefix path
        blobs = bucket.list_blobs(prefix=args.path + "/D", delimiter="/")
        for blob in tqdm(blobs):
            print(blob)
            print(os.getcwd())
            # file path where the blob data from Google Storage is stored
            filename = f"./pipeline/data/{blob.name.split('/')[-1]}"
            # create an empty file on the specified path
            open(filename, 'a', 'utf-8').close()
            # download and append the data in the file created before
            blob.download_to_filename(f"./pipeline/data/{blob.name.split('/')[-1]}")
        
        imgs = [Mat.read(file) for file in sorted(glob.glob("pipeline/data/D*.JPG"))]

    # Get test data
    imgs = imgs[:4]

    # Run the pipeline
    pipeline = nutrient_pipeline()
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
