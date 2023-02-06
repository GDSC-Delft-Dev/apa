from modules.module import Module

class Config:
    def __init__(self, modules: list[Module]):
        self.modules: list[Module] = modules
