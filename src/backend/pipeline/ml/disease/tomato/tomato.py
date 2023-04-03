import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from ....utils import performance_visualization


def ResNetTomato():
    """
    Create a ResNet50 model for the tomato disease classification task.
    """
    # create a ResNet50 model
    resnet = tf.keras.applications.ResNet50(
        include_top=False,
        weights="imagenet",
        input_shape=(256, 256, 3),
        pooling="avg",
    )
    # freeze the weights of the model
    resnet.trainable = False
    # add a dense layer with 10 output units, each correspoding to a class
    # in utils.py
    output = tf.keras.layers.Dense(10, activation="softmax")(resnet.output)
    model = tf.keras.Model(inputs=resnet.input, outputs=output)
    return model

def train(model: tf.keras.Model, dataset: tuple[np.ndarray, np.ndarray], 
          optimizer: tf.keras.optimizers.Optimizer,
          loss: tf.keras.losses.Loss):
    """
    Train the model on the PlantVillage dataset.
    Assume the model is not compiled yet.
    
    Args:
       model - tf.keras.Model to finetune
       dataset - np.ndarray of shape (num_train_imgs x width x height x channels)
       optimizer - tf.keras.optimizers.Optimizer to use
       loss - tf.keras.losses.Loss to use
    """

    model.compile(
        optimizer=optimizer,
        loss=loss,
        metrics=["accuracy"],
    )
    # shuffle data
    perm = np.random.permutation(dataset[0].shape[0])
    dataset = (dataset[0][perm], dataset[1][perm])

    train_data = (dataset[0][:int(0.8 * dataset[0].shape[0])], dataset[1][:int(0.8 * dataset[0].shape[0])])
    val_data = (dataset[0][int(0.8 * dataset[0].shape[0]):], dataset[1][int(0.8 * dataset[0].shape[0]):])

    # load the dataset

    train_dataset = tf.data.Dataset.from_tensor_slices((train_data[0], train_data[1]))
    val_dataset = tf.data.Dataset.from_tensor_slices((val_data[0], val_data[1]))

    # shuffle the dataset 
    SHUFFLE_SIZE = 10000
    BATCH_SIZE = 32
    train_dataset = train_dataset.shuffle(SHUFFLE_SIZE).batch(BATCH_SIZE)
    val_dataset = val_dataset.shuffle(SHUFFLE_SIZE).batch(BATCH_SIZE)

    print(f"Number of samples in the training set: {train_data[0].shape[0]}")
    print(f"Number of samples in the validation set: {val_data[0].shape[0]}")

    # pre-fetch data for performance
    AUTOTUNE = tf.data.AUTOTUNE
    train_dataset = train_dataset.prefetch(buffer_size=AUTOTUNE)
    validation_dataset = val_dataset.prefetch(buffer_size=AUTOTUNE)

    hist = model.fit(train_dataset, 
                     epochs=15,
                     validation_data=validation_dataset)
    
    performance_visualization(hist)
    return model
