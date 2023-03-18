# pylint: disable=R0903
from .modules.module import Module
from .modules.runnable import Runnable
from typing import Any, Type
from dataclasses import dataclass

@dataclass
class CloudConfig:
    """
    Configures cloud resources.

    Args:
        use_cloud: True if the pipeline uses cloud, False otherwise
        bucket_name: name of the bucket for the pipeline input
        staged_input: True if the input is staged from a local system, False otherwise
        input_path: full bucket path to the input files
    """
    use_cloud: bool = False
    bucket_name: str = ""
    staged_input: bool = False
    input_path: str = ""

class Config:
    """
    Initializes the config.

    Args:
        modules: dictionary of modules to initialize and their initialization data
        cloud: data class containing necessary information for Google Cloud usage
    """
    def __init__(self, modules: dict[Type[Module], Any], cloud: CloudConfig = CloudConfig()):
        assert len(modules) > 0, "No modules specified"
        self.modules: dict[Type[Module], Any] = modules
        self.cloud: CloudConfig = cloud
