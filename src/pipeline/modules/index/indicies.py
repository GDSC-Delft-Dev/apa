from enum import Enum

"""
Represents module types.
"""
class Indicies(Enum):
    NDVI = "NDVI",
    NUTRIENT = "NUTRIENT",
    DOUBLEPLANT = "DOUBLEPLANT",
    DRYDOWN = "DRYDOWN",
    ENDROW = "ENDROW",
    PLANTERSKIP = "PLANTERSKIP",
    WATER = "WATER",
    WATERWAY = "WATERWAY",
    WEEDCLUSTER = "WEEDCLUSTER"