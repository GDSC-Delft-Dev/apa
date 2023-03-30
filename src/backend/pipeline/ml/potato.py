import tensorflow as tf
from .utils import create_dataset
from .disease.potato import ResNetPotato, train

def main():
    LEARNING_RATE = 3e-4 # learning rate
    dataset = create_dataset()
    model = ResNetPotato()
    optimizer = tf.keras.optimizers.Adam(learning_rate=LEARNING_RATE)
    loss = tf.losses.CategoricalCrossentropy()
    model = train(model, dataset, optimizer, loss)
    model.save("potato_model/resnet_potato")
    print(f"Finished")

main() # run main
