from .module import Module
from .data import Data
from ..mat import Mat
from .modules import Modules
from ..mat import Channels
import cv2
import numpy as np
import asyncio
from typing import Any

class Mosaicing(Module):
    """
    Pipeline module for mosaicing (stitching) images
    """

    def __init__(self, data: Data, input_data: Any = None) -> None:
        super().__init__(data, name="Mosaicing", module_type=Modules.MOSAIC)

    def run(self, data: Data) -> None:
        """
        Stitches the images to create an orthomosaic image of the farm.
        
        Args:
            data: the pipeline data object with the input images
            input_data: the module initialization data

        Raises:
            Exception: when the sticher fails to stich the images
        """

        self.prepare(data)
        # Check if there are multiple input images
        if len(data.input) == 1:
            data.modules[self.type.value]["stitched"] = data.input[0]
            patches = self.create_patches(data.input[0], data.input[0].channels) 
            data.modules[self.type.value]["patches"] = patches

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
            data.modules[self.type.value]["stitched"] = stitched
            # data.persistable[self.type.value]["stitched"] = stitched.get()
            # calculate the masks that are used to ignore certain
        # parts of the image and the a new Mat that contains an
        # alpha channel 
        stitched = data.modules[self.type.value]["stitched"]
        mask, alpha_stitched = self.process(data.modules[self.type.value]["stitched"])
        data.modules[self.type.value]["mask"] = mask
        data.modules[self.type.value]["alpha_img"] = alpha_stitched
        patches = self.create_patches(stitched, data.input[0].channels)
        data.modules[self.type.value]["patches"] = patches

    def to_persist(self, data: Data):
        data.persistable[self.type.value] = frozenset([self.type.value + "." + "stitched"])

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
            
    def process(self, img: Mat) -> tuple[np.ndarray, Mat]:
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
