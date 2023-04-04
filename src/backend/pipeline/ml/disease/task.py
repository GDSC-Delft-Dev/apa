import argparse
from .model import keras_estimator, input_fn, serving_input_fn
from .mappings import mappings
from ..utils import create_dataset
import numpy as np
import tensorflow as tf
import os
import subprocess

# working directory
WORKING_DIR = os.getcwd()
# Google Cloud Storage bucket
SUPPORTED = ['potato', 'tomato']


def download_files_from_gcs(sources: list[str], destinations: list[str]):
    """
    Download files from Google Cloud Storage from the specified sources and destinations.

    Args:
        sources: list of GCS paths
        destinations: list of local paths
    """
    for source, dest in zip(sources, destinations):
        subprocess.check_call(['gsutil', 'cp', source, dest])
    
def load_data(bucket: str, labels: list[str], val_split: float = 0.2) -> tuple[tuple, tuple]:
    """
    Load and preprocess dataset from local file system.

    Args:
        val_split: validation split

    Returns:
        tuple of tuples containing the training and validation data and labels
    """
    assert 0 <= val_split < 1

    # download data from GCS
    sources = ["gs://" + bucket + "/" + label + "/*" for label in labels]
    destinations = [WORKING_DIR + "/data/" + label + "/" for label in labels]
    download_files_from_gcs(sources, destinations)

    # TODO: give the paths as parameters instead of hardcoding them in utils.py
    data, dlabels = create_dataset()

    # shuffle data
    perm = np.random.permutation(data.shape[0])
    dataset = (data[perm], dlabels[perm])

    # split in train and validation data
    train_data = (dataset[0][:int((1-val_split) * dataset[0].shape[0])], dataset[1][:int((1-val_split) * dataset[0].shape[0])])
    val_data = (dataset[0][int((1-val_split) * dataset[0].shape[0]):], dataset[1][int((1-val_split) * dataset[0].shape[0]):])
    return train_data, val_data 

def get_args():
    """
    """
    parser = argparse.ArgumentParser()
    parser.add_argument(
    	'--job-dir',
    	type=str,
    	help='GCS location to write checkpoints and export models')
    parser.add_argument(
    	'--test-split',
    	type=float,
    	default=0.2,
    	help='Split between training and test, default=0.2')
    parser.add_argument(
    	'--num-epochs',
    	type=float,
    	default=500,
    	help='number of times to go through the data, default=500')
    parser.add_argument(
    	'--batch-size',
    	type=int,
    	default=128,
    	help='number of records to read during each training step, default=128')
    parser.add_argument(
    	'--verbosity',
    	choices=['DEBUG', 'ERROR', 'FATAL', 'INFO', 'WARN'],
    	default='INFO')
    parser.add_argument(
        '--crop',
        type=str,
        help="type of crop from the supported crops")
    args, _ = parser.parse_known_args()
    assert args.crop in SUPPORTED
    return args

def train_and_evaluate(args: argparse.Namespace):
    """
    Train and evaluate the model on GCP

    Args:
        args: command line arguments
    """
    train_dict: dict = mappings[args.crop]
    # load data
    (train_data, train_labels), (test_data, test_labels) = load_data(train_dict["bucket"], 
                                                                     train_dict["labels"])
    # save checkpoints every this many steps
    run_config = tf.estimator.RunConfig(save_checkpoints_steps=500)
    # number of training steps
    train_steps = args.num_epochs * len(train_data) / args.batch_size

    # specifications for training
    train_spec = tf.estimator.TrainSpec(
    	input_fn=lambda: input_fn(
    		train_data,
    		train_labels,
    		args.batch_size,
    		mode=tf.estimator.ModeKeys.TRAIN),
    	max_steps=train_steps)
    exporter = tf.estimator.LatestExporter('exporter', serving_input_fn)
    # specifications for evaluation
    eval_spec = tf.estimator.EvalSpec(
    	input_fn=lambda: input_fn(
    		test_data,
    		test_labels,
    		args.batch_size,
    		mode=tf.estimator.ModeKeys.EVAL),
    	steps=None,
    	exporters=[exporter],
    	start_delay_secs=10,
    	throttle_secs=10)
    # define estimator
    estimator = keras_estimator(
        train_dict["model"](), # initialize model
    	model_dir=args.job_dir,
    	config=run_config)
    tf.estimator.train_and_evaluate(estimator, train_spec, eval_spec)

if __name__ == '__main__':
    args = get_args()
    tf.logging.set_verbosity(args.verbosity)
    train_and_evaluate(args)