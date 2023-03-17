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

## Running
To run the default pipeline you'll need Python 3.10. First, install the necessary requirements with

`pip install -r requirements.txt`

You can then run the default pipeline with

`py main.py`

As there are multiple ways to run a pipeline, there is a list of arguments that can be used to specify options. Here is an exhaustive list of the supported arguments:
- path - specify the path on Google Cloud Storage where the input images are located. If not path is specified, the input images will be from the local filesystem. 
- mode - specify if the input images are already in the cloud or need to be uploaded first from the local filesystem.

#### Examples

Run the pipeline with images already in the cloud:
`py main.py --path path/to/images --mode cloud`

Run the pipeline with images on your local filesystem:
`py main.py --path path/to/images --mode local`

Run the pipeline without Google Cloud:
`py main.py`

### Trigger an image processing job on Google Cloud Platform

Manual triggers allow you to run the latest pipeline builds from the Artifact Registry with custom input data using Cloud Run.
You can run a job with either input data from your local file system or input data that already resides in the cloud.

Custom inputs to the pipeline are removed from Google Cloud only if the pipeline run is successful.

#### Provide input data from a local filesystem

```bash
sudo chmod +x trigger.sh
./trigger.sh -l /path/to/data/ -n name-of-the-job
```

#### Provide input data from Cloud Storage

```bash
sudo chmod +x trigger.sh
./trigger.sh -c /path/to/data/ -n name-of-the-job
```

### Testing
To test the code, run `pytest` unit tests:

```
python -m pytest
```

### Static analysis
Our project uses `mypy` and `pylint` to assert the quality of the code. You can run these with:

```
python -m mypy . --explicit-package-bases
python -m pylint ./pipeline
```

### CI/CD
The CI/CD pushes the build from the latest commit to the `pipelines-dev` repository in the Google Artifact Registry.

### Modules
To make the code extendible, maintainable, and multithreaded, the pipeline is divided into modules. Modules are run sequentially, and each can have multiple implementations that execute different logic, but compute the same type of data. We distinguish the following modules:
- Mosaicing module - transforms the flyover images into a single farmland bird's eye view image. Moreover the module creates non-overlapping patches used in subsequent pipeline stages.
- Index module - computes pixel-level indicies that provide general information about the field
- Insight module - evaluates the database and indicies to provide actionable and localized insights that identify issues and improve farming efficiency
- Segmentation module - computes pixel-level masks for a number of different annotations that can be directly shown to the user
- Preprocessing module - performs a number of image preprocessing steps depending on the usage of the result further in the pipeline. Most commonly it is a prerequisite before the Index and Segmentation module

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

### Implementing modules
The pipeline modules utilize OOP principles heavily in order to be chainable, and to enable simple performance reporting and analytics. We discern three types of module-related objects and the pipeline data object:

<img src='uml.png' width="600">

To add functionality, implement one of these abstract classes.

#### Runnable
The runnable is the simplest form of a pipeline element. While it is the building block of modules, the user can implement Runnables that are run by modules (such as `NDVI`).

#### Module
The module is a logical part of the image processing pipeline, chained sequentially with other pipelines. A module will perform its functionality when being `run()` and save the relevant data in the pipeline data object that will be passed to the following module. Note that your implementation should invoke `super().run(data)` after your module logic. 

#### Parallel module
The parallel module is a module that can run multiple threads of execution at the same time, essentially allowing parallel module invocations. Parallel modules implement logical groups of functionalities, such as the calculation of all indicies (e.g. `NDVI` and `Mositure`) that do not rely on each other.

#### Pipeline data object
The data object contains all data relevant to the pipeline job. The pipeline initializes the data object dynamically through the use of the `prepare()` method. Note that, similarily to constructors, the preparation of your implementation should follow the preparation of the base class.
