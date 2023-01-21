from __future__ import annotations
from enum import Enum
from screeninfo import get_monitors
from .runnable import Runnable
from .data import Data
import cv2

"""
Represents an arbitrary image processing pipeline module.
"""
class Module(Runnable):
    def __init__(self, name: str):  
        self.name: str = name
        self.next: Module = None

    """
    Processes the image.

    Args:
        data: the job data
        persist: whether to save the images to the field database
    """
    def run(self, data: Data) -> any:
        # If there is a next module, then run it
        if self.next != None:
            self.next.prepare(data)
            return self.next.run(data)

        # Otherwise, return the data
        return data

    def display(self, img: cv2.Mat):
        # Adjust the image size
        monitor = get_monitors()[0]
        print(img.shape, monitor.width, monitor.height)
        f = min(monitor.width / img.shape[0], monitor.height / img.shape[1])
        print(f)
        if f < 1.0:
            img = cv2.resize(img, (int(img.shape[0] * f * 0.8), int(img.shape[1] * f * 0.8)))
        
        # Display the image
        cv2.imshow(self.name, img)
        cv2.waitKey()
        cv2.destroyWindow(self.name)

    """
    Prepares the module to be run.
    """
    def prepare(self, data: Data):
        print(f"Running module <{self.name}>")
        data.stages.append({
            "name": self.name,
        })

    """
    Adds the provided module to the chain.
    
    Args:
        module: the module to add to the chain
    """
    def add(self, module: Module):
        if self.next:
            self.next.add(module)
        self.next = module
        print(f"Added module <{self.name}>")

"""
Represents module types.
"""
class Modules(Enum):
    PREPROCESS = 0,
    MOSAIC = 1,
    INDEX = 2,
    INSIGHT = 3