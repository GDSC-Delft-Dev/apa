from __future__ import annotations
from ..parallel_module import ParallelModule
from .runnables.ndvi import NDVI
from .indicies import Indicies
from ..data import Data, Modules
from ..runnable import Runnable

"""
Pipeline module for calculating indicies
"""
class Index(ParallelModule):
    def __init__(self):
        super().__init__("Index")
        self.runnables: dict[Indicies, Runnable] = {
            Indicies.NDVI: NDVI
        }

    def prepare(self, data: Data):
        super().prepare(data)
        data.modules[Modules.INDEX] = {
            "indicies": {}
        }

        for index in self.runnables:
            self.runnables[index].prepare(data)