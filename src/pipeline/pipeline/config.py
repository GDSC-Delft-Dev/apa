from .modules.module import Module
from .mat import Mat

class Config:
    """
    Initializes the config.

    Args:
        modules: dictionary of modules to initialize and their initialization data
    """
    def __init__(self, modules: dict[Module, any]):
        self.modules: dict[Module, any] = modules
        