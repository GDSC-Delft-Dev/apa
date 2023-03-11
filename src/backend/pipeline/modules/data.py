from __future__ import annotations
from ..mat import Mat
from .modules import Modules
from typing import Any
import uuid

class Data:
    """
    Represents the pipeline data object.

    Args:
        uuid: unique identifier for the pipeline object
        input: the pipeline input
        stages: the list pipeline stages ready for configuration
        current: the current pipeline stage; initially none
    """
    def __init__(self, uuid: uuid) -> None:
        self.uuid = uuid
        self.input: list[Mat] = []
        self.modules: dict[Modules, Any] = {module_type : {"input": {}} for module_type in Modules}
        self.persistable: dict[Modules, list] = {module_type: {frozenset([])} for module_type in Modules}
        self.current: None | Modules = None

    def set(self, img: Mat | list[Mat]) -> None:
        """
        Sets the input images.

        Args:
            img: the images to process
        """
        self.input = img if isinstance(img, list) else [img]

    def get_module(self, module: Modules) -> dict:
        """
        Provides the data of the specified module.
        
        Returns:
            The data of the specified module.
        """
        return self.modules[module]

    def get_current(self) -> dict:
        """
        Provides the data of the currently worked module.
        
        Returns:
            The data of the currently worked module, or None if there isn't one.
        """
        if self.current is None:
            raise Exception("Cannot get current module as the current module isn't set")

        return self.modules[self.current.value]
    
    def get_persistable(self, module: Modules) -> list:
        """
        Provide the persistable entities that need to be saved to the cloud.

        Args:
            module: specific module

        Returns:
            The data that should be saved to Storage after the module was executed.
        """
        return self.persistable[module.value]
