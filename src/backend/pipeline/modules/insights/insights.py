from enum import Enum

class Insights(Enum):
    """Represents insight types."""
    # Disease
    TOMATO = "Tomato"

class Tomato(Enum):
    """Represents tomato disease types."""

    # Bacterial spot
    BACTERIAL_SPOT = 0
    # Early blight
    EARLY_BLIGHT = 1
    # Late blight
    LATE_BLIGHT = 2
    # Leaf mold
    LEAF_MOLD = 3
    # Septoria leaf spot
    SEPTORIA_LEAF_SPOT = 4
    # Spider mites
    SPIDER_MITES = 5
    # Target spot
    TARGET_SPOT = 6
    # Tomato yellow leaf curl virus
    TOMATO_YELLOW_LEAF_CURL_VIRUS = 7
    # Tomato mosaic virus
    TOMATO_MOSAIC_VIRUS = 8
    # Healthy
    HEALTHY = 9

# mapping from insight to specific enum
insights_mapping = {
    Insights.TOMATO: Tomato
}


