from enum import Enum

class Modules(Enum):
    """Represents module types."""
    
    DEFAULT = "Default"
    PREPROCESS = "Preprocess"
    MOSAIC = "Mosaic"
    INDEX = "Index"
    INSIGHT = "Insight"
    SEGMENTATION = "Segmentation"