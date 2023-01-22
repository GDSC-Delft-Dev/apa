from __future__ import annotations
import cv2
from .module import Modules
from mat import Mat

"""
Represents the pipeline data object.

Args:
    input: the pipeline input
    stages: the list pipeline stages ready for configuration
    current: the current pipeline stage; initially none
"""
class Data:
    def __init__(self, input: list[Mat] | Mat):
        self.input: list[Mat] | Mat = input
        self.modules: dict([(module_type, {}) for module_type in Modules])
        self.current: None | Modules = None

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