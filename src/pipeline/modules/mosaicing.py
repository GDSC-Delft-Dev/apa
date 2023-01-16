from .module import Module
import cv2

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
    def run(self, img: list[cv2.Mat], rest: any) -> cv2.Mat:
        self.prepare()
        
        # Initiate the stitcher
        stitcher = cv2.Stitcher_create() 
        stitcher.setWaveCorrection(False)

        # Run the algorithm
        status, stitched = stitcher.stitch([img[0], img[1]])
        if status != cv2.Stitcher_OK:
            print("Error stitching images: code " + str(status))
            raise Exception("The stiching failed")
            
        # Run the next module
        return super().run(stitched, rest=None, save=True)