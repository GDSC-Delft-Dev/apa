from __future__ import annotations
from mat import Mat
from .modules import Modules
from typing import Any

class Data:
    """
    Represents the pipeline data object.

    Args:
        input: the pipeline input
        stages: the list pipeline stages ready for configuration
        current: the current pipeline stage; initially none
    """
    def __init__(self) -> None:
        self.input: list[Mat] | Mat = []
        self.modules: dict(tuple[Modules, Any]) = {module_type : {"input": {}} for module_type in Modules}
        self.current: None | Modules = None

    def set(self, img: Mat | list[Mat]) -> None:
        """
        Sets the input images.

        Args:
            img: the images to process
        """
        self.input = img

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
        return self.modules[self.current]
