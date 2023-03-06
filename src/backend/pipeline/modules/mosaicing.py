from .module import Module
from .data import Data
from ..mat import Mat
from .modules import Modules
import cv2
import asyncio
from typing import Any

class Mosaicing(Module):
    """
    Pipeline module for mosaicing (stitching) images
    """

    def __init__(self, data: Data, input_data: Any = None) -> None:
        super().__init__(data, name="Mosaicing", module_type=Modules.MOSAIC)

    def run(self, data: Data) -> Data:
        """
        Stitches the images to create an orthomosaic image of the farm.
        
        Args:
            data: the pipeline data object with the input images
            input_data: the module initialization data

        Raises:
            Exception: when the sticher fails to stich the images

        Returns:
            The stiched image.
        """

        self.prepare(data)
        # Check if there are multiple input images
        if len(data.input) == 1:
            data.modules[self.type]["stitched"] = data.input[0]
            patches = self.create_patches(data.input[0], data.input[0].channels) 
            data.modules[self.type]["patches"] = patches
            data.persistable[self.type].add("stitched")

        else:
            # Initiate the stitcher
            stitcher = cv2.Stitcher_create() 
            stitcher.setWaveCorrection(False)

            # Run the algorithm
            status, stitched = stitcher.stitch([mat.get() for mat in data.input])
            if status != cv2.Stitcher_OK:
                print("Error stitching images: code " + str(status))
                raise Exception("The stiching failed")

            # Make a mat
            stitched = Mat(stitched, data.input[0].channels) 
            data.modules[self.type]["stitched"] = stitched
            data.persistable[self.type]["stitched"] = stitched.get()

            # split the image into equal patches for the segmentation module
            patches = self.create_patches(stitched, data.input[0].channels) 
            data.modules[self.type]["patches"] = patches

        return super().run(data)
    
    def create_patches(self, stitched: Mat, channels) -> list[Mat]:
        """
        Divide the stitched image into equal patches.

        Args:
            stitched: the stitched image
            channels: a list of Channels

        Returns:
            A list of equal sized patches
        """
        height = width = 512
        # Calculate the number of patches to create
        num_patches_horizontal = stitched.get().shape[1] // width
        num_patches_vertical = stitched.get().shape[0] // height

        patches: list[Mat] = []
        # Loop through the image and extract each patch
        for i in range(num_patches_vertical):
            for j in range(num_patches_horizontal):
                patch = stitched.get()[i*height:(i+1)*height, j*width:(j+1)*width, :]
                patches.append(Mat(patch, channels))

        return patches
