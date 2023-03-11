# type: ignore
from __future__ import annotations
from ..parallel_module import ParallelModule
from .runnables.ndvi import NDVI
from ..data import Data, Modules
from typing import Any


class Index(ParallelModule):
    """Pipeline module for calculating indicies."""

    def __init__(self, data: Data, input_data: Any):
        """Initializes the index module and its runnables."""
        super().__init__(data, [NDVI], name="Index", module_type=Modules.INDEX)
