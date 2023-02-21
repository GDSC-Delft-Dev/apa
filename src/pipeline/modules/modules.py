from enum import Enum

"""
Represents module types.
"""
class Modules(Enum):
    DEFAULT = "Default"
    PREPROCESS = "Preprocess"
    MOSAIC = "Mosaic"
    INDEX = "Index"
    INSIGHT = "Insight"
    SEGMENTATION = "Segmentation"