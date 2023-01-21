from __future__ import annotations
import cv2
from .module import Module
from .data import Data
from .runnable import Runnable
from concurrent.futures import ThreadPoolExecutor, as_completed

"""
Represents an arbitrary image processing pipeline module that can
run multiple runnables at the same time.
"""
class ParallelModule:
    def __init__(self, name: str):  
        super().__init__(name)
        self.runnables: dict[int, Runnable] = {}

    """
    Processes the image using the runnables.

    Args:
        img: the input image(s)
        rest: non-specific module arguments
        save: whether to save the images to the field database
    """
    def run(self, data: Data) -> any:
        # Spawn the executor
        # TODO: don't hardcode max_workers
        with ThreadPoolExecutor(max_workers=4) as executor:
            # Run the runnables
            futures = {executor.submit(runnable.run, data): runnable for runnable in self.runnables}
            for future in as_completed(futures):
                # TODO: assign results
                pass
                
        # Run the module functionality
        return super().run(data)

    """
    Prepares the module to be run.
    """
    def prepare(self, data: Data):
        print(f"Running parallel module <{self.name}>")
        data.stages.append({
            "name": self.name,
            "runnables": {}
        })

        for runnable in self.runnables:
            runnable.prepare(data)