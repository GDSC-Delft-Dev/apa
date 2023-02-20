from enum import Enum

"""
Represents module types.
"""
class Indicies(Enum):
    # Normalized Differential Vegetation Index. Suggests whether the area contains live vegetation
    NDVI = "NDVI"
    # Nutrient Deficiency Index. Suggests whether the plants in the area exhibit some sort of deficiency.
    # with respect to nutrients
    NUTRIENT = "NUTRIENT"
    # Double Plant index. Suggests whether some area is populated by more than one plant type.
    DOUBLEPLANT = "DOUBLEPLANT"
    # Drydown index. Suggests whether the plants in some area undergo drying, the loss of moisture.
    DRYDOWN = "DRYDOWN"
    # Endrow index. Suggests the border crops that may require some special treatment.
    ENDROW = "ENDROW"
    # Planter skip index. Suggests the area where planting did not occur.
    PLANTERSKIP = "PLANTERSKIP"
    # Water index. Suggests whether the area has a surplus of water.
    WATER = "WATER"
    # Waterway index. Suggests whether the area is occupied by a waterway.
    WATERWAY = "WATERWAY"
    # Weed cluster index. Suggests whether the area has a concentrated group of weeds.
    WEEDCLUSTER = "WEEDCLUSTER"