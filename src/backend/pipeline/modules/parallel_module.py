from __future__ import annotations
import cv2
import pickle
import pydash
from .module import Module
from .data import Data
from .runnable import Runnable
from .modules import Modules
from concurrent.futures import ThreadPoolExecutor, wait
from typing import Any, Type

class ParallelModule(Module):
    """
    Represents an arbitrary image processing pipeline module that can
    run multiple runnables at the same time.
    """

    def __init__(self, data: Data, runnables: list[Type[Runnable]], input_data: Any = None,
                 name: str = "Unnamed parallel module", module_type: Modules = Modules.DEFAULT):
        """
        Initializes the parallel module.

        Args:
            data: the pipeline data object
            runnables: list of runnables to run in parallel
            input_data: the module initialization parameters
            name: the name of the module
            type: the type of the module
        """
 
        super().__init__(data, input_data, name=name, module_type=module_type)

        # Initialize runnables
        self.runnables: list[Runnable] = [runnable(data) for runnable in runnables]

    def run(self, data: Data) -> Data:
        """
        Processes the image using the runnables.

        Args:
            img: the input image(s)
            data: the job data
        """
        
        # Spawn the executor
        # TODO: don't hardcode max_workers
        with ThreadPoolExecutor(max_workers=4) as executor:
            # Run the runnables
            print("Parallel module running " +\
                ', '.join(["<" + runnable.name + ">" for runnable in self.runnables]))
            futures = {executor.submit(runnable.run, data): runnable for runnable in self.runnables}

            # Wait for completion
            # TODO: add validation
            wait(futures)

        # Run the module functionality
        return super().run(data)

    def prepare(self, data: Data) -> None:
        """Prepares the module to be run."""

        # Initialize the module data
        super().prepare(data)
        data.modules[self.type.value]["runnables"] = {}

        # Initialize runnables' data
        for runnable in self.runnables:
            runnable.prepare(data)

    def upload(self, data: Data, collection, bucket, base_url: str):
        """Upload data to Google Storage."""
        try:
            uris = []
            for k, v in data.modules[self.type.value]["runnables"].items():
                for persist in data.persistable[self.type.value]["runnables"][k]:
                    path = persist.replace(".","/")
                    blob = bucket.blob(str(data.uuid) + "/" + path)
                    uris.append(base_url + str(data.uuid) + "/" + path)
                    # get persistable from the specified dict path
                    value = pydash.get(data.modules, persist)
                    blob.upload_from_string(pickle.dumps({persist.split(".")[-1]: value}))

            collection.document(str(data.uuid)).update({
                str(self.type): uris
            })
            print(f"Persistable data from module {self.type} uploaded.")
            return True
        except Exception as exception:
            print(exception)
            print(f"Data could not be uploaded for {self.type}!") 
            return False
