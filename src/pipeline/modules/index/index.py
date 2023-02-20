from __future__ import annotations
from ..parallel_module import ParallelModule
from .runnables.ndvi import NDVI
from ..data import Data, Modules
from typing import Any

"""
Pipeline module for calculating indicies
"""
class Index(ParallelModule):
    """
    Initializes the index module and its runnables.
    """
    def __init__(self, data: Data, input: Any):
        super().__init__("Index", Modules.INDEX, [NDVI], data)
        
    def prepare(self, data: Data):
        # Initialize the module data
        super().prepare(data)
