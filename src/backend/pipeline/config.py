# pylint: disable=R0903
from .modules.module import Module
from .modules.runnable import Runnable
from typing import Any, Type

class Config:
    """
    Initializes the config.

    Args:
        modules: dictionary of modules to initialize and their initialization data
    """
    def __init__(self, modules: dict[Type[Module], Any], bucket_name: str):
        assert len(modules) > 0, "No modules specified"
        self.modules: dict[Type[Module], Any] = modules
        self.bucket_name = bucket_name
