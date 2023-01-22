from .module import Module
from .data import Data
from mat import Mat
import cv2

"""
Pipeline module for mosaicing (stitching) images
"""
class Mosaicing(Module):
    def __init__(self):
        super().__init__("Mosaicing")

    """
    Sitches the images to create an orthomosaic image of the farm.
    
    Args:
        images: the images to stich

    Raises:
        Exception: when the sticher fails to stich the images

    Returns:
        The stiched image
    """
    def run(self, data: Data) -> cv2.Mat:
        self.prepare(data)
        
        # Check if there are multiple input images
        if isinstance(data.input, Mat):
            data.stitched = data.input

        else:
            # Initiate the stitcher
            stitcher = cv2.Stitcher_create() 
            stitcher.setWaveCorrection(False)

            # Run the algorithm
            status, stitched = stitcher.stitch(data.input)
            if status != cv2.Stitcher_OK:
                print("Error stitching images: code " + str(status))
                raise Exception("The stiching failed")
            data.stitched = stitched
            
        # Run the next module
        return super().run(data)