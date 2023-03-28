import tensorflow as tf
from utils import *
from disease.tomato import *

def main():
    LR = 3e-4 # learning rate
    dataset = create_dataset()
    model = ResNetTomato()
    optimizer = tf.keras.optimizers.Adam(learning_rate=LR)
    loss = tf.losses.CategoricalCrossentropy()
    model = train(model, dataset, optimizer, loss)
    print(f"Finished")

main() # run main