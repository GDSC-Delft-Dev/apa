from enum import Enum

class Insights(Enum):
    """Represents insight types."""
    # Disease
    TOMATO = "Tomato"

class Tomato(Enum):
    """Represents tomato disease types."""

    # Bacterial spot
    BACTERIAL_SPOT = "Bacterial spot"
    # Early blight
    EARLY_BLIGHT = "Early blight"
    # Late blight
    LATE_BLIGHT = "Late blight"
    # Leaf mold
    LEAF_MOLD = "Leaf mold"
    # Septoria leaf spot
    SEPTORIA_LEAF_SPOT = "Septoria leaf spot"
    # Spider mites
    SPIDER_MITES = "Spider mites"
    # Target spot
    TARGET_SPOT = "Target spot"
    # Tomato yellow leaf curl virus
    TOMATO_YELLOW_LEAF_CURL_VIRUS = "Tomato yellow leaf curl virus"
    # Tomato mosaic virus
    TOMATO_MOSAIC_VIRUS = "Tomato mosaic virus"
    # Healthy
    HEALTHY = "Healthy"

# mapping from insight to specific enum
insights_mapping = {
    Insights.TOMATO: Tomato
}


