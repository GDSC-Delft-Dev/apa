from __future__ import annotations
import cv2
from ..mat import Channels
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
 
        super().__init__(data, 
                        input_data=input_data, 
                        name=name, 
                        module_type=module_type)

        # Initialize runnables
        self.runnables: list[Runnable] = [runnable(data) for runnable in runnables]
        self.channels: list[Channels] = list(set(sum([runnable.channels for runnable in self.runnables], [])))

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
    
    def verify(self, channels: list[Channels]) -> bool:
        """
        Verifies that the module's runnables can run on the given channels.

        Args:
            channels: the channels to verify

        Returns:
            True if all the module can run on the given channels, False otherwise
        """

        # Set the default return value
        satisfied: bool = True

        # Verify all the runnables
        for runnable in self.runnables:
            if not runnable.verify(channels):
                satisfied = False
                
        return satisfied

    def prepare(self, data: Data) -> None:
        """Prepares the module to be run."""

        # Initialize the module data
        super().prepare(data)
        data.modules[self.type]["runnables"] = {}

        # Initialize runnables' data
        for runnable in self.runnables:
            runnable.prepare(data)