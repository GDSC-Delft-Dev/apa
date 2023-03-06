from .module import Module
from .data import Data
from ..mat import Mat
from .modules import Modules
from ..mat import Channels
import cv2
import numpy as np
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

        # calculate the masks that are used to ignore certain
        # parts of the image and the a new Mat that contains an
        # alpha channel 
        mask, alpha_stitched = self.process(data.modules[self.type]["stitched"])
        data.modules[self.type]["mask"] = mask
        data.modules[self.type]["alpha_img"] = alpha_stitched
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
    
    def process(self, img: Mat) -> (np.ndarray, Mat):
        """
        Extract and process information from the orthomosaic image.

        Args:
            img: a Mat object containing the stitched image
        
        Returns:
            tuple consisting of a np.ndarray and a new Mat 
            representation
        """
        # collapse channels to ensure all are 0
        collapsed = np.sum(img.get(), axis=2)
        # create the mask
        mask = np.where(collapsed == 0.0, 1, 0)
        # expand the number of dimensions for concatenation
        mask = np.expand_dims(mask, 2)
        alpha_image = np.concatenate((img.get(), mask), axis=2)
        return np.where(mask == 1, 0, 1), Mat(alpha_image, channels=[Channels.R, 
                            Channels.G, Channels.B, Channels.A])