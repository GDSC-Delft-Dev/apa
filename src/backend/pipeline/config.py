# pylint: disable=R0903
from .modules.module import Module
from typing import Any, Type

class Config:
    """
    Initializes the config.

    Args:
        modules: dictionary of modules to initialize and their initialization data
    """
    def __init__(self, modules: dict[Type[Module], Any]):
        self.modules: dict[Type[Module], Any] = modules
        