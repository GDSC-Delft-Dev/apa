# pylint: disable=R0903
from .modules.module import Module
from .modules.runnable import Runnable
from typing import Any, Type
from dataclasses import dataclass

@dataclass
class CloudConfig:
    """Configures cloud resources."""
    use_cloud: bool = False
    bucket_name: str = ""

class Config:
    """
    Initializes the config.

    Args:
        use_cloud: whether use cloud resources, e.g. persist data to cloud storage.
                   If False, the user doesn't need to provide GCP credentials.
        modules: dictionary of modules to initialize and their initialization data
    """
    def __init__(self, modules: dict[Type[Module], Any], cloud: CloudConfig = CloudConfig()):
        assert len(modules) > 0, "No modules specified"
        self.modules: dict[Type[Module], Any] = modules
        self.cloud: CloudConfig = cloud
