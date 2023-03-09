import copy
from typing import Any, Type
from .modules.module import Module
from .modules.parallel_module import ParallelModule
from .mat import Mat, Channels
from .modules.data import Data
from .modules.index.index import Index
from .config import Config

class Pipeline:
    """
    The image processing pipeline object. Pipelines take in images and process them
    with the modules specified in their configuration.
    """

    def __init__(self, config: Config):
        """Build the pipeline according to the configuration."""
        # Build the data object
        self.data_proto: Data = Data()

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
        else:
            return module(self.data_proto, input_data=input_data)

    def run(self, imgs: Mat | list[Mat]) -> Data:
        """
        Runs the pipeline on the provided input images.

        Args:
            img: the input image(s)
            rest: non-specific module arguments

        Returns:
            The processed data.
        """

        # Check that the channels of all images are the same
        if not isinstance(imgs, Mat):
            channels = [img.channels for img in imgs]
            assert len(imgs) > 0, "No images provided"
            assert channels.count(channels[0]) == len(channels), "Images have different channels"

        # Construct input data
        data = copy.deepcopy(self.data_proto)
        data.set(imgs)

        # Verify input integrity
        if self.verify(imgs):
            # Run the chain
            self.head.run(data)
        
        return data
    
    def verify(self, imgs: Mat | list[Mat]) -> bool:
        """
        Verifies that the pipeline is valid.
        
        Args:
            imgs: the input imasges

        Returns:
            Whether the pipeline is valid.
        """

        # Extract channels present in all images and set the default return value
        channels = set.intersection(*[set(img.channels) for img in imgs])
        satisfied: bool = True

        # Iterate through all modules to check whether their band
        # requirements are satisfied
        tail: Module = self.head
        while tail is not None:
            # Verify the module
            if not tail.verify(channels):
                satisfied = False

            # Set the next module
            tail = tail.next

        return satisfied

    def show(self):
        """Prints out the current state of the pipeline."""

        print("-- Pipeline --")
        tail = self.head
        while tail:
            print(f"<{tail.name}>")
            tail = tail.next
        print("----")
