## Pipeline

The image processing pipeline is the main construct of our project. When provided with images from a flyover, the pipeline computes indicies (i.e. vegetation index, mositure content) to estimate relevant information and provides insights (e.g. nutrient deficiencies, infestations) locally. This data is saved in the database, and can be visualized in the user interface, or used for further analysis (e.g. model training, statistical analysis).

<p align="center">
    <p align="center">
        <img src="test\data\mosaicing\farm\multiple.png" width="300" />
        &nbsp &nbsp
        <img src="test\data\mosaicing\farm\stitched.PNG" width="300" />
    </p>
</p>
<p align="center">Example of image mosaicing</p>

### Modules
To make the code extendible, maintainable, and multithreaded, the pipeline is divided into modules. Modules are run sequentially, and each can have multiple implementations that execute different logic, but compute the same type of data. We distinguish the following modules:
- Mosaicing module - transforms the flyover images into a single farmland bird's eye view image
- Index module - computes pixel-level indicies that provide general information about the field
- Insight module - evaluates the database and indicies to provide actionable and localized insights that identify issues and improve farming efficiency

Each module automatically verifies its dependencies (e.g. to identify moisture content near-infrared spectrum is required) and provide statistics about no. of executions, success rates, and processing times.

### Pipeline configuration
To configure a pipeline you must provide the input data and module types you'd like to run. This is done through the config class:
```
from .types import Modules
from pipeline import Pipeline

cfg = Config(modules=[MOSAIC, INDEX, INSIGHT])
pipeline = Pipeline(cfg)
```
Running this code will spawn a pipeline instance that can perform a job. The pipeline creation might fail if the configuration is invalid, e.g. when the user wants to detect an insight that relies on the `NDVI` index, but that index isn't calculated by the pipeline.

### Running the pipeline
To run the pipeline use `.run()`:
```
from .Mat import Mat

imgs: list[Mat] = ...
pipeline.run(imgs)
```

Note that the input images must be wrapped in the `Mat` class (wrapping a `cv2.Mat` class) to support images with various multispectral layouts.

