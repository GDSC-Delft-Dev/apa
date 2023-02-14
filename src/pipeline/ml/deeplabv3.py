import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers


def convolution_block(
    block_input,
    num_filters=256,
    kernel_size=3,
    dilation_rate=1,
    padding="same",
    use_bias=False,
):
    """
    Basic convolution block --> conv layer - batch norm - activation function

    Args: 
        block_input: TF input tensor
        num_filters: number of filters in the convolution layer
        kernel_size: kernel size
        dilation_rate: dilation rate used for determining the dilation for convolution
        padding: image padding
        use_bias: add bias parameter

    Returns:
        TF tensor representing the activations from the conv block
    """
    x = layers.Conv2D(
        num_filters,
        kernel_size=kernel_size,
        dilation_rate=dilation_rate,
        padding="same",
        use_bias=use_bias,
        kernel_initializer=keras.initializers.HeNormal(),
    )(block_input)
    x = layers.BatchNormalization()(x)
    return tf.nn.relu(x)


def DilatedSpatialPyramidPooling(dspp_input):
    # dimensions of the input
    dims = dspp_input.shape
    x = layers.AveragePooling2D(pool_size=(dims[-3], dims[-2]))(dspp_input)
    # apply 1x1 conv to perform dimensionality reduction and apply non-linearity
    x = convolution_block(x, kernel_size=1, use_bias=True)
    # upsample tensor to get original 
    out_pool = layers.UpSampling2D(
        size=(dims[-3] // x.shape[1], dims[-2] // x.shape[2]), interpolation="bilinear",
    )(x)
    # apply a series of atrous convolutions to maintain feature maps sizes
    out_1 = convolution_block(dspp_input, kernel_size=1, dilation_rate=1)
    out_6 = convolution_block(dspp_input, kernel_size=3, dilation_rate=6)
    out_12 = convolution_block(dspp_input, kernel_size=3, dilation_rate=12)
    out_18 = convolution_block(dspp_input, kernel_size=3, dilation_rate=18)

    # concatenate all outputs from conv layers 
    x = layers.Concatenate(axis=-1)([out_pool, out_1, out_6, out_12, out_18])
    # apply 1x1 conv
    output = convolution_block(x, kernel_size=1)
    return output

def DeepLabV3Plus(image_size: int, num_classes: int, channels: int):
    """
    Architecture of the DeepLabv3+ model for multi-class semantic segmentation
    """
    model_input = keras.Input(shape=(image_size, image_size, channels))

    # backbone model for extracting low-level features
    if channels == 3:
        # use pretrained weights
        resnet50 = keras.applications.ResNet50(
            weights="imagenet", include_top=False, input_tensor=model_input
        )
    else:
        # initialize random weights as there is no pretrained model
        resnet50 = keras.applications.ResNet50(
            weights=None, include_top=False, input_tensor=model_input
        )
    x = resnet50.get_layer("conv4_block6_2_relu").output

    x = DilatedSpatialPyramidPooling(x)

    # upsampling to recover dimensions after pooling
    input_a = layers.UpSampling2D(
        size=(image_size // 4 // x.shape[1], image_size // 4 // x.shape[2]),
        interpolation="bilinear",
    )(x)

    input_b = resnet50.get_layer("conv2_block3_2_relu").output
    input_b = convolution_block(input_b, num_filters=48, kernel_size=1)
    x = layers.Concatenate(axis=-1)([input_a, input_b])
    x = convolution_block(x)
    x = convolution_block(x)
    x = layers.UpSampling2D(
        size=(image_size // x.shape[1], image_size // x.shape[2]),
        interpolation="bilinear",
    )(x)

    model_output = layers.Conv2D(num_classes, kernel_size=(1, 1), padding="same")(x)
    return keras.Model(inputs=model_input, outputs=model_output)



