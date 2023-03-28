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