import tensorflow as tf


def keras_estimator(model, model_dir, config) -> tf.estimator.Estimator:
    """
    Create a Keras Estimator from a Keras Model.

    Args:
        model: Keras Model
        model_dir: directory to save model parameters, graph and etc.
        config: configuration for Estimator
	
	Returns:
        tf.estimator.Estimator
    """
    optimizer = tf.keras.optimizers.Adam(learning_rate=3e-4)
    loss = tf.losses.CategoricalCrossentropy()
    model.compile(
        optimizer=optimizer,
        loss=loss,
        metrics=["accuracy"],
    )
    return tf.keras.estimator.model_to_estimator(keras_model=model, model_dir=model_dir, config=config)

def input_fn(features, labels, batch_size, mode):
	"""
	Input function for the Estimator.
	
	Args:
        features: np.ndarray of input shape
        labels: np.ndarray of output shape
        batch_size: batch size
        mode: tf.estimator.ModeKeys
    """
	if labels is None:
		inputs = features
	else:
		inputs = (features, labels)
	dataset = tf.data.Dataset.from_tensor_slices(inputs)
	if mode == tf.estimator.ModeKeys.TRAIN:
		dataset = dataset.shuffle(1000).repeat().batch(batch_size)
	if mode in (tf.estimator.ModeKeys.EVAL, tf.estimator.ModeKeys.PREDICT):
		dataset = dataset.batch(batch_size)
	return dataset.make_one_shot_iterator().get_next()

def serving_input_fn(input_shape: tuple) -> tf.estimator.export.TensorServingInputReceiver:
	"""
	Input function for serving.
	
	Args:
        input_shape: shape of input tensor
	
	Returns:
        tf.estimator.export.TensorServingInputReceiver
    """
	feature_placeholder = tf.placeholder(tf.float32, input_shape)
	features = feature_placeholder
	return tf.estimator.export.TensorServingInputReceiver(features, feature_placeholder)