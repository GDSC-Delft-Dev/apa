import copy
from typing import Any, Type
from .modules.module import Module
from .modules.parallel_module import ParallelModule
from .mat import Mat
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

        # merge the simple module dict with the parallel dict
        config.modules.update(config.parallel_modules)
        # Build the head
        head_config = next(iter(config.modules.items()))
        if issubclass(head_config, ParallelModule):
            self.head: ParallelModule = head_config[0](self.data_proto, 
                                    runnables=head_config[1][0], 
                                    input_data=head_config[1][1])
        else:
            self.head: Module = head_config[0](self.data_proto, input_data=head_config[1])
        # Build the rest
        tail: Module = self.head
        for module, input_data in list(config.modules.items())[1:]: #type: tuple[Type[Module], Any]
            if issubclass(module, ParallelModule):
                tail.next = module(self.data_proto, runnables=input_data[0], 
                                   input_data=input_data[1])
            else:
                print(type(module))
                tail.next = module(self.data_proto, input_data=input_data)
            tail = tail.next

    def run(self, imgs: Mat | list[Mat]) -> Data:
        """
        Runs the pipeline on the provided input images.

        Args:
            img: the input image(s)
            rest: non-specific module arguments

        Returns:
            The processed data.
        """

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
        self.head.run(data)
        return data

    def show(self):
        """Prints out the current state of the pipeline."""

        print("-- Pipeline --")
        tail = self.head
        while tail:
            print(f"<{tail.name}>")
            tail = tail.next
        print("----")
