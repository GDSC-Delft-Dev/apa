from modules.data import Modules

class Config:
    def __init__(self, modules: list[Modules]):
        self.modules: list[Modules] = modules
