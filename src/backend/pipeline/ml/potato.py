import tensorflow as tf
from utils import *
from disease.potato import *

def main():
    LR = 3e-4 # learning rate
    dataset = create_dataset()
    model = ResNetPotato()
    optimizer = tf.keras.optimizers.Adam(learning_rate=LR)
    loss = tf.losses.CategoricalCrossentropy()
    model = train(model, dataset, optimizer, loss)
    model.save("potato_model/resnet_potato")
    print(f"Finished")

main() # run main