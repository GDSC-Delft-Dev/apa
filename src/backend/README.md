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

## Machine Learning

Working at the intersection between Computer Vision and Deep Learning, we are using state-of-the-art methods to provide additional insights to the farmer that are not so easy to extract using the classic methods. The models we are using are first trained offline using publicly available data. Each time new data comes in from a customer, we are fine-tuning the existing models in order to ensure good performance over time. Moreover, this online training method allows for easy extension to new types of data and insights.

## Applications

Given the flexibility and wide range of the arhitectures in Computer Vision, there are many different ways you can use raw image data to extract either insights (directly accesible to the farmer) or high-dimensional features that can be further used by the pipeline.

Here is an exhaustive list of the methods used:
- Semantic Segmentation - extract 9 different annotations from aerial image data, that can be used as masks 


## Semantic Segmentation

Semantic segmentation is a computer vision technique that involves dividing an image into multiple segments, each of which corresponds to a particular object or region in the image. The goal of semantic segmentation is to accurately label each pixel in an image with the class of the object it belongs to, such as "person," or "car".

In the context of our application, semantic segmentation is used to identify area of interest for the farmer. One example would be a patch of land that has a surplus of water. Using this technique, we can accurately point to the specific problem, allowing the farmer to deal with the problem. Moreover, this techique can be used to allow the UAV to perform a closer inspection on areas that might be of interest.

### DeepLabv3+

Link to the paper [here](https://arxiv.org/abs/1802.02611).

DeepLabv3+ is a semantic segmentation architecture that solves a critical problems classic CNNs have in segmentation. By performing downsampling multiple times the feature maps (filters) become smaller and smaller which results in the loss of boundary information. The way the architecture solves this problem is by using atrous convolutions, also known as dilated convolution. This type of convolution allows for better results by preserving segmentation information throughout the network. 

The architecture itself employs an encoder-decoder structure.

Usually the model is used in combination with a pretrained model (e.g. ResNet) that extracts low-level features from the raw images. However, due to the available channels in our data, there is a need to use a multitude of models that can accomodate different number of channels.

The code that corresponds to the model implementation is in **deeplabv3.py** and makes use of Google's Tensorflow framework.


## Disease detection

For a number of supported crops, we can use computer vision to detect different types of diseases from an early stage and notify the user about the problem. 

### List of supported crops
- Tomato

### Method

In order to detect diseases, we employ both a fine-tuning and transfer learning strategy (depending on the scenario) using pre-trained model like Resnet. Moreover, the training is done 
using publicly available data (e.g. Google Datasets, Kaggle etc.)

Specific training code for a certain crop can be found in **disease/** folder.
