import tensorflow as tf
import numpy as np
import glob
import cv2
import matplotlib.pyplot as plt

class Args:

    # base path
    base_path: str = "../../PlantVillage/"
    # individual classes
    classes: list[str] = [
       "Tomato_Bacterial_spot/",
       "Tomato_Early_blight/",
       "Tomato_Late_blight/",
       "Tomato_Leaf_Mold/",
       "Tomato_Septoria_leaf_spot/",
       "Tomato_Spider_mites_Two_spotted_spider_mite/",
       "Tomato__Target_Spot/",
       "Tomato__Tomato_YellowLeaf__Curl_Virus/",
       "Tomato__Tomato_mosaic_virus/",
       "Tomato_healthy/"
    ]


def read_class(path: str) -> np.ndarray:
    """
    Get all images from a specified directory and transform them in a np.ndarray

    Args:
        path - path to image folder

    Returns:
        np.ndarray of shape (num_imgs x width x height x channels)
    """

    imgs = [cv2.imread(file) for file in sorted(glob.glob(path + "*.JPG"))]
    return np.array(imgs, dtype=np.float32)


def preprocessing(imgs: np.ndarray,
                  mean: list[float] = [0.485, 0.456, 0.406], 
                  stddev: list[float] = [0.229, 0.224, 0.225]) -> np.ndarray:
    """
    Preprocessing step on training and validation images.

    Args:
        imgs - input images
        mean - mean for each channel in an RGB image
        stddev - standard deviation for each channel in an RGB image
    """
    return np.divide((imgs - mean), stddev) 


def create_dataset() -> tuple[np.ndarray, np.ndarray]:
    """
    Create dataset for training and validation from the PlantVillage images.
    Apply standard prprocessing steps.

    Returns:
        tuple of np.ndarrays containing the images and labels
    """
    data, labels = [], []
    for idx, _class in enumerate(Args.classes):
        imgs = read_class(Args.base_path + Args.classes[idx])
        # sample from this bc too much memory
        imgs = imgs[np.random.choice(imgs.shape[0], 250, replace=False)]

        data.append(preprocessing(imgs))
        # one-hot of the index of the class
        labels.append(tf.one_hot(np.full(imgs.shape[0], idx), len(Args.classes)))
        print(labels[-1].shape)
        print(f"Images with label {idx}: {imgs.shape[0]}")
    return np.concatenate(data), np.concatenate(labels)
        
def performance_visualization(history):
    """
    Visualize the performance of the model with respect to accuracy and loss
    during training.

    Args:
        history - history of the model during training
    """

    acc = history.history['accuracy']
    val_acc = history.history['val_accuracy']

    loss = history.history['loss']
    val_loss = history.history['val_loss']

    plt.figure(figsize=(8, 8))
    plt.subplot(2, 1, 1)
    plt.plot(acc, label='Training Accuracy')
    plt.plot(val_acc, label='Validation Accuracy')
    plt.legend(loc='lower right')
    plt.ylabel('Accuracy')
    plt.ylim([min(plt.ylim()),1])
    plt.title('Training and Validation Accuracy')

    plt.subplot(2, 1, 2)
    plt.plot(loss, label='Training Loss')
    plt.plot(val_loss, label='Validation Loss')
    plt.legend(loc='upper right')
    plt.ylabel('Cross Entropy')
    plt.ylim([0,1.0])
    plt.title('Training and Validation Loss')
    plt.xlabel('epoch')
    plt.show()
