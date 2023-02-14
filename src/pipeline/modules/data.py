from __future__ import annotations
from mat import Mat
from .types import Modules

"""
Represents the pipeline data object.

Args:
    input: the pipeline input
    stages: the list pipeline stages ready for configuration
    current: the current pipeline stage; initially none
"""
class Data:
    def __init__(self):
        self.input: list[Mat] | Mat = None
        self.modules: dict([(module_type, {"input": {}}) for module_type in Modules]) = {}
        self.current: None | Modules = None

    """
    Sets the input images.

    Args:
        img: the images to process
    """
    def set(self, img: Mat | list[Mat]):
        self.input = img

    """
    Provides the data of the specified module.
    
    Returns:
        The data of the specified module.
    """
    def get_module(self, module: Modules) -> dict:
        return self.modules[module]

    """
    Provides the data of the currently worked module.
    
    Returns:
        The data of the currently worked module, or None if there isn't one.
    """
    def get_current(self) -> dict:
        return self.modules[self.current]