from __future__ import annotations
import cv2
from .module import Module
from .data import Data
from .runnable import Runnable
from .types import Modules
from concurrent.futures import ThreadPoolExecutor, wait

"""
Represents an arbitrary image processing pipeline module that can
run multiple runnables at the same time.
"""
class ParallelModule(Module):
    """
    Initializes the parallel module.

    Args:
        name: the name of the module
        type: the type of the module
        runnables: list of runnables to run in parallel
        data: the pipeline data object
    """
    def __init__(self, name: str, type: Modules, runnables: list[Runnable], data: Data):  
        super().__init__(name, type, data)

        # Initialize runnables
        self.runnables: list[Runnable] = [runnable(data) for runnable in runnables] 

    """
    Processes the image using the runnables.

    Args:
        img: the input image(s)
        data: the job data
    """
    def run(self, data: Data) -> any:
        # Spawn the executor
        # TODO: don't hardcode max_workers
        with ThreadPoolExecutor(max_workers=4) as executor:
            # Run the runnables
            print("Parallel module running " + ', '.join(["<" + runnable.name + ">" for runnable in self.runnables]))
            futures = {executor.submit(runnable.run, data): runnable for runnable in self.runnables}

            # Wait for completion
            # TODO: add validation
            wait(futures)
                
        # Run the module functionality
        return super().run(data)

    """
    Prepares the module to be run.
    """
    def prepare(self, data: Data):
        # Initialize the module data
        super().prepare(data)
        data.modules[self.type]["runnables"] = {}

        # Initialize runnables' data
        for runnable in self.runnables:
            runnable.prepare(data)
