import tensorflow as tf
from .utils import create_dataset
from .disease.tomato.tomato import ResNetTomato, train

def main():
    LEARNING_RATE = 3e-4 # learning rate
    dataset = create_dataset()
    model = ResNetTomato()
    optimizer = tf.keras.optimizers.Adam(learning_rate=LEARNING_RATE)
    loss = tf.losses.CategoricalCrossentropy()
    model = train(model, dataset, optimizer, loss)
    model.save("tomato_model/resnet_tomato")
    print(f"Finished")

main() # run main
