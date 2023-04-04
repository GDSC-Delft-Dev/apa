from .potato import potato
from .tomato import tomato

mappings = {
    "tomato": {
        "bucket": "terrafarm-plantvillage-tomato",
        "labels": ['bacterial_spot', 'early_blight', 'healthy', 
                   'late_blight', 'leaf_mold', 'septoria_leaf_spot', 
                   'spider_mites', 'target_spot', 'mosaic_virus', 
                   'yellow_leaf_curl_virus'],
        "model": tomato.ResNetTomato
    },
    "potato": {
        "bucket": "terrafarm-plantvillage-potato", 
        "labels": ['early_blight', 'healthy', 'late_blight'],
        "model": potato.ResNetPotato
    }
}
