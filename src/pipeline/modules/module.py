from __future__ import annotations
from screeninfo import get_monitors
from .runnable import Runnable
from .data import Data
from .modules import Modules
from mat import Mat
import cv2
from typing import Any, Type

"""
Represents an arbitrary image processing pipeline module.
"""
class Module(Runnable):
    """
    Initializes the module metadata and the data object.

    Args:
        name: the name of the module
        type: the type of the module
    """
    def __init__(self, name: str, type: Modules, data: Data):  
        self.name: str = name
        self.next: Module | None = None
        self.type: Modules = type

    @classmethod
    def build(cls, config: tuple[Type[Module], Any]) -> Module:
        pass

    """
    Processes the image.

    Args:
        data: the job data
        persist: whether to save the images to the field database
    """
    def run(self, data: Data) -> Any:
        # If there is a next module, then run it
        if self.next is not None:
            print(f"Preparing <{self.name}>")
            self.next.prepare(data)
            print(f"Running <{self.name}>")
            return self.next.run(data)

        # Otherwise, return the data
        return data

    def display(self, img: Mat):
        # Adjust the image size
        monitor = get_monitors()[0]

        # Calculate the scaling factor
        shape = img.get().shape
        f = min(monitor.width / shape[0], monitor.height / shape[1])
        if f < 1.0:
            img = img.make(cv2.resize(img.get(), (int(shape[0] * f * 0.8), int(shape[1] * f * 0.8))))
        
        # Display the image
        cv2.imshow(self.name, img.get())
        cv2.waitKey()
        cv2.destroyWindow(self.name)

    """
    Prepares the module to be run.
    """
    def prepare(self, data: Data):
        super().prepare(data)
        data.modules[self.type] = {}