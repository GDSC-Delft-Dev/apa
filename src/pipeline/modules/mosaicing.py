from .module import Module
from .data import Data
from mat import Mat
from .types import Modules
import cv2

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
            data.modules[self.type]["stitched"] = Mat(stitched, data.input[0].channels)
            
        # Run the next module
        return super().run(data)