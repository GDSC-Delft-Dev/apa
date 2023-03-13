import copy
from typing import Any, Type
from .modules.module import Module
from .modules.parallel_module import ParallelModule
from .mat import Mat, Channels
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

        # Save config
        self.config = config
        
        # Give the pipeline object a unique id
        self.uuid = uuid.uuid4()

        # Build the data object
        self.data_proto: Data = Data(self.uuid)

        # Build the head
        head_config = next(iter(config.modules.items()))
        self.head = self.build_module(head_config[0], head_config[1])

        # Build the rest
        tail: Module = self.head
        for module, input_data in list(config.modules.items())[1:]: #type: tuple[Type[Module], Any]
            tail.next = self.build_module(module, input_data)
            tail = tail.next

    def build_module(self, module: Type[Module], input_data: Any) -> Module:
        """
        Builds a module and returns it.

        Args:
            module: the module class
            input_data: the module initialization parameters

        Returns:
            The module object.
        """

        if issubclass(module, ParallelModule):
            return module(self.data_proto, 
                          runnables=input_data["runnables"],
                          input_data=input_data["config"])

        return module(self.data_proto, input_data=input_data)

    async def run(self, imgs: Mat | list[Mat]) -> Data:
        """
        Runs the pipeline on the provided input images.

        Args:
            img: the input image(s)
            rest: non-specific module arguments

        Returns:
            The processed data.
        """

        # Initialize cloud resources
        print("Use cloud: " + str(self.config.cloud.use_cloud))
        if self.config.cloud.use_cloud:
            # Connect to Cloud Storage
            self.storage_client = storage.Client()
            self.bucket = self.storage_client.bucket(self.config.cloud.bucket_name)

            # Set base URL
            self.base_url = "https://storage.cloud.google.com/" + self.config.cloud.bucket_name + "/"

            # Connect to Firestore client
            self.client = firestore.client()
            self.collection = self.client.collection('test')

            # Start time of the pipeline
            # TODO: change to server-side timestamp
            self.collection.document(str(self.uuid)).set({
                'id': str(self.uuid),
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

        # Verify input integrity
        if not self.verify(data.input):
            raise RuntimeError("Pipeline input integrity violated")

        # Run the chain
        iterator: Module | None = self.head
        failed: bool = False
        while iterator is not None:
            # Run the module
            try:
                data = iterator.run(data)
            except Exception as exception:
                failed = True

            # Upload data to the cloud asynchronously
            if self.config.cloud.use_cloud:
                asyncio.create_task(
                    asyncio.to_thread(
                        iterator.upload(data, self.collection, self.bucket, self.base_url)))
            
            # Go to the next module
            iterator = iterator.next

        # Log end time of the pipeline
        if self.config.cloud.use_cloud:
            self.collection.document(str(self.uuid)).update({
                'end': time.time()
            })

        if self.config.cloud.staged_input == True and failed == False:
            bucket = self.storage_client.bucket("terrafarm-inputs")
            blobs=bucket.list_blobs(prefix=self.config.cloud.input_path + "/", delimiter="/")
            for blob in blobs:
                print(blob)
                blob.delete()

        return data
    
    def verify(self, imgs: list[Mat]) -> bool:
        """
        Verifies that the pipeline is valid.
        
        Args:
            imgs: the input imasges

        Returns:
            Whether the pipeline is valid.
        """

        # Extract channels present in all images and set the default return value
        channels: list[Channels] = list(set.intersection(*[set(img.channels) for img in imgs]))
        satisfied: bool = True

        # Iterate through all modules to check whether their band
        # requirements are satisfied
        tail: Module | None = self.head
        while tail is not None:
            # Verify the module
            if not tail.verify(channels):
                satisfied = False

            # Set the next module
            tail = tail.next

        return satisfied

    def show(self):
        """Prints out the current state of the pipeline."""

        print(f"-- Pipeline ({self.uuid})--")
        tail = self.head
        while tail:
            print(f"<{tail.name}>")
            tail = tail.next
        print("----")
