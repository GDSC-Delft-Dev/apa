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
    """
    Initializes the index module and its runnables.
    """
    def __init__(self, data: Data, input: any):
        super().__init__("Index", Modules.INDEX, data)
        data.modules[self.type]["indicies"] = {}

        # TODO: don't harcode runnables
        self.runnables: list[Runnable] = []
        for runnable in [NDVI]:
            self.runnables.append(runnable(data))


    def prepare(self, data: Data):
        super().prepare(data)

        for index in self.runnables:
                self.runnables[index].prepare(data)
            