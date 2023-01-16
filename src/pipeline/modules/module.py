from __future__ import annotations
import cv2

"""
Represents an arbitrary image processing pipeline module.
"""
class Module:
    def __init__(self, name: str):  
        self.name: str = name
        self.next: Module = None

    """
    Processes the image.

    Args:
        img: the input image(s)
        rest: non-specific module arguments
        save: whether to save the images to the field database
    """
    def run(self, img: cv2.Mat | list[cv2.Mat], rest: any, save: bool = True) -> any:
        # TODO: save the images
        cv2.imshow("img", img)
        cv2.waitKey()
        cv2.destroyAllWindows()

        # If there is a next module, then run it
        if self.next != None:
            return self.next.run(img, rest)

        # Otherwise, return the arguments
        return rest

    """
    Prepares the module to be run.
    """
    def prepare(self):
        print(f"Running module <{self.module}>")

    """
    Adds the provided module to the chain.
    
    Args:
        module: the module to add to the chain
    """
    def add(self, module: Module):
        if self.next:
            self.next.add(module)
        self.next = module
        print(f"Added module <{self.module}>")