from __future__ import annotations
from screeninfo import get_monitors
from .runnable import Runnable
from .data import Data
from .modules import Modules
from ..mat import Mat
import cv2
from typing import Any
import pickle
from google.cloud import storage
from firebase_admin import firestore

class Module(Runnable):
    """
    Represents an arbitrary image processing pipeline module.
    """

    def __init__(self, data: Data, input_data: Any = None,
                 name: str = "Unnamed module", module_type: Modules = Modules.DEFAULT):  
        """
        Initializes the module metadata and the data object.

        Args:
            data: the pipeline data object
            input_data: the module initialization parameters
            name: the name of the module
            type: the type of the module

        Attributes:
            next: the next module in the chain
        """
        super().__init__(data, name)
        self.next: Module | None = None
        self.type: Modules = module_type

    def run(self, data: Data) -> Any:
        """
        Processes the image.

        Args:
            data: the job data
            persist: whether to save the images to the field database
        """

        # If there is a next module, then run it
        if self.next is not None:
            print(f"Preparing <{self.name}>")
            data.current = self.next.type
            self.next.prepare(data)
            print(f"Running <{self.name}>")
            return self.next.run(data)

        # Otherwise, return the data
        return data

    def display(self, img: Mat) -> None:
        """
        Downscales and displays an image to fit your monitor.
        
        Args:
            img: the image to display
        """
        
        # Adjust the image size
        monitor = get_monitors()[0]

        # Calculate the scaling factor
        shape = img.get().shape
        scale = min(monitor.width / shape[0], monitor.height / shape[1]) * 0.8
        if scale < 1.0:
            img = img.make(cv2.resize(img.get(), (int(shape[0] * scale), int(shape[1] * scale))))
        
        # Display the image
        cv2.imshow(self.name, img.get())
        cv2.waitKey()
        cv2.destroyWindow(self.name)

    def prepare(self, data: Data):
        """Prepares the module to be run."""

        data.modules[self.type] = {}

    def upload(self, bucket_name: str, data: Data):
        """Upload data to Google Storage."""
        
        base_url: str = "https://storage.cloud.google.com/" + bucket_name + "/"
        try:
            # connect to firestore
            db = firestore.client()
            # get 'pipelines' collection
            collection = db.collection('pipelines')
            storage_client = storage.Client() 
            bucket = storage_client.bucket(bucket_name)
            uris = []
            for k, v in data.persistable[self.type].items():
                blob = bucket.blob(str(data.uuid) + "/" + k)
                uris.append(base_url + str(data.uuid) + "/" + k)
                blob.upload_from_string(pickle.dumps(v))

            collection.document(str(data.uuid)).update({
                str(self.type): uris
            })
            print(f"Persistable data from module {self.type} uploaded.")
            return True
        except Exception as exception:
            print(exception)
            print(f"Data could not be uploaded for {self.type}!") 
            return False