import copy
from typing import Any, Type
from .modules.module import Module
from .mat import Mat
from .modules.data import Data
from .config import Config
import uuid
import asyncio
from firebase_admin import firestore
from google.cloud import storage
import time

class Pipeline:
    """
    The image processing pipeline object. Pipelines take in images and process them
    with the modules specified in their configuration.
    """

    def __init__(self, config: Config):
        """Build the pipeline according to the configuration."""

        
        # Give the pipeline object a unique id
        self.uuid = uuid.uuid4()

        # Build the data object
        self.data_proto: Data = Data(self.uuid)

        # Connect to Cloud Storage
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(config.bucket_name)

        # Set base URL
        self.base_url = "https://storage.cloud.google.com/" + config.bucket_name + "/"

        # Connect to Firestore client
        self.client = firestore.client()
        self.collection = self.client.collection('test')

        # Build the head
        head_config = next(iter(config.modules.items()))
        self.head: Module = head_config[0](self.data_proto, input_data=head_config[1])

        # Build the rest
        tail: Module = self.head
        for module, input_data in list(config.modules.items())[1:]: #type: tuple[Type[Module], Any]
            tail.next = module(self.data_proto, input_data=input_data)
            tail = tail.next

    async def run(self, imgs: Mat | list[Mat]) -> Data:
        """
        Runs the pipeline on the provided input images.

        Args:
            img: the input image(s)
            rest: non-specific module arguments

        Returns:
            The processed data.
        """
        # start time of the pipeline
        self.collection.document(str(self.uuid)).set({
            'id': str(self.uuid),
        })
        self.collection.document(str(self.uuid)).update({
            'start': time.time()
        })

        # Verify input integrity
        # Check that the channels of all images are the same
        if not isinstance(imgs, Mat):
            channels = [img.channels for img in imgs]
            assert len(imgs) > 0, "No images provided"
            assert channels.count(channels[0]) == len(channels), "Images have different channels"

        # Construct input data
        data = copy.deepcopy(self.data_proto)
        data.set(imgs)

        # Run the chain
        iterator = self.head
        while iterator is not None:
            # Run the module
            data = iterator.run(data)
            # Upload data to the cloud async
            asyncio.create_task(asyncio.to_thread(
            iterator.upload(data, self.collection, self.bucket, self.base_url)
            ))
            # Go to the next module
            iterator = iterator.next
        # log end time of the pipeline
        self.collection.document(str(self.uuid)).update({
            'end': time.time()
        })
        return data
    

    def show(self):
        """Prints out the current state of the pipeline."""

        print(f"-- Pipeline ({self.uuid})--")
        tail = self.head
        while tail:
            print(f"<{tail.name}>")
            tail = tail.next
        print("----")
