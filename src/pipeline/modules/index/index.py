from __future__ import annotations
from ..parallel_module import ParallelModule
from enum import Enum
from runnables.ndvi import NDVI

"""
Represents module types.
"""
class Indicies(Enum):
    NDVI = 0

"""
Pipeline module for calculating indicies
"""
class Index(ParallelModule):
    def __init__(self):
        super().__init__()
        self.runnables = {
            Indicies.NDVI: NDVI
        }