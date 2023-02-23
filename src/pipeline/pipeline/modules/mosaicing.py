from .module import Module
from .data import Data
from ..mat import Mat
from .types import Modules
import cv2
import numpy as np

"""
Pipeline module for mosaicing (stitching) images
"""
class Mosaicing(Module):
    def __init__(self, data: Data, input: any):
        super().__init__("Mosaicing", Modules.MOSAIC, data)

    """
    Sitches the images to create an orthomosaic image of the farm.
    
    Args:
        data: the pipeline data object with the input images

    Raises:
        Exception: when the sticher fails to stich the images

    Returns:
        The stiched image.
    """
    def run(self, data: Data):
        self.prepare(data)
        
        # Check if there are multiple input images
        if isinstance(data.input, Mat):
            data.stitched = data.input

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

            # split the image into equal patches for the segmentation module
            # height and width of the patches
            height = width = 512
            channels = data.input[0].channels

            # Calculate the number of patches to create
            num_patches_horizontal = stitched.get().shape[1] // width
            num_patches_vertical = stitched.get().shape[0] // height

            patches: list[Mat] = []
            # Loop through the image and extract each patch
            for i in range(num_patches_vertical):
                for j in range(num_patches_horizontal):
                    patch = stitched.get()[i*height:(i+1)*height, j*width:(j+1)*width, :]
                    patches.append(Mat(patch, channels))
            # save the calculated patches for further usage
            data.modules[self.type]["patches"] = patches
            
        # Run the next module
        return super().run(data)
