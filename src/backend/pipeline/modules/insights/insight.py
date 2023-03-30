from abc import ABC, abstractmethod
from ..data import Data
from ..parallel_module import ParallelModule
from ..runnable import Runnable
from typing import Any
from ..modules import Modules

class Insight(ParallelModule):
    """Pipeline module for calculating insights."""

    def __init__(self, data: Data, runnables: list[type[Runnable]], input_data: Any):
        """Initializes the insight module and its runnables."""
        super().__init__(data, runnables, name="Insight", module_type=Modules.INSIGHT)
