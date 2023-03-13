import glob
import sys
import os
import argparse
from pipeline.templates import full_pipeline, default_pipeline
from pipeline.mat import Mat
from google.cloud import storage

def main():
    """Main entry point."""

    # parse arguments
    parser = argparse.ArgumentParser(description='Process cloud arguments')
    parser.add_argument('--path', dest='path', default=None)
    parser.add_argument('--mode', dest='mode', default=None)
    namespace = parser.parse_args(sys.argv[1:])
    path = namespace.path
    mode = namespace.mode

    # check if we use cloud data or local data
    if path is None or mode is None:
        imgs = [Mat.read(file) for file in glob.glob("pipeline/test/data/mosaicing/farm/D*.JPG")]
    else:
        if not os.path.exists("./pipeline/data"):
            os.mkdir("./pipeline/data/")
        storage_client = storage.Client()
        if mode == "local":
            bucket = storage_client.get_bucket("terrafarm-inputs")
        else:
            bucket = storage_client.get_bucket("terrafarm-test")

        blobs=bucket.list_blobs(prefix=path + "/D", delimiter="/")
        for blob in blobs:
            print(blob)
            print(os.getcwd())
            filename = f"./pipeline/data/{blob.name.split('/')[-1]}"
            open(filename, 'a').close()
            blob.download_to_filename(f"./pipeline/data/{blob.name.split('/')[-1]}")
        
        imgs = [Mat.read(file) for file in glob.glob("pipeline/data/D*.JPG")]

    # Run the pipeline
    pipeline = default_pipeline()
    pipeline.show()
    res = pipeline.run(imgs)

    # Print the result
    print(res)

if __name__ == "__main__":
    main()
