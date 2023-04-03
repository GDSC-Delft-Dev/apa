from setuptools import find_packages
from setuptools import setup

REQUIRED_PACKAGES = [
    'notebook==6.5.2',
    'pandas==1.5.2',
    'numpy==1.24.1',
    'opencv-python==4.7.0.68',
    'matplotlib==3.6.2',
    'screeninfo==0.8.1',
    'tensorflow==2.10.0',
    'matplotlib==3.6.2',
    'mypy==1.0.1',
    'pylint==2.16.2',
    'pytest==7.2.1',
    'google-cloud-storage==2.7.0',
    'google-cloud-firestore==2.10.0',
    'argparse==1.4.0',
    'firebase-admin==6.1.0',
    'pydash==6.0.2',
    'pytest-asyncio==0.20.3',
    'tqdm==4.65.0',
]

setup(
    name='disease',
    version='0.1',
    install_requires=REQUIRED_PACKAGES,
    packages=find_packages(),
    include_package_data=True,
    requires=[]
)