<!-- TODO: add code coverage? -->
# Terrafarm

![example workflow](https://github.com/GDSC-Delft-Dev/apa/actions/workflows/pipeline.yml/badge.svg)

Terrafarm is an autonomous farming solution provides a comprehensive way to monitor crops at any scale. We provide farmers with the ability to scrutinize every square inch of their fields for a wide range of issues. By detecting crop diseases before they spread, Terrafarm can reduce the usage of harmful chemicals by up to 90% and eradicate invasive species regionally. As the application provides health reports, farmers can optimize fertilizer use and reduce preventive pesticide, herbicide, and fungicide use. 

Want to know more? Read our wiki [**here**](../../wiki).

## Getting Started

### Backend

The backend comprises of the image processing pipleline that processes mutlispectral images from farms. You can run it locally, or remotely on GCP (in a container). If you'd like to know more about the pipeline, read our wiki [**here**](../../wiki/Pipeline).

#### Local setup
Run the image processing pipeline locally. Tested on linux (`Ubuntu 20`) and Mac (`Ventura 13`). Components that do not involve ML training can also be run on `Windows 10`.

1. Install [**Python 3.10**](https://www.python.org/downloads/)

2. Clone the repo

```
git clone https://github.com/GDSC-Delft-Dev/apa.git
```

3. Setup the Python virtual environment 
```
pip install virtualenv
virtualenv env
source env/bin/activate (linux, mac)
source env/Scripts/activate (windows)
```

4. Install Python requirements
```
cd src/backend
pip install -r requirements.txt
```

5. Run the pipeline
```
py main.py
```

The supported arguments for `main.py` are:
- `mode` (`local`/`cloud`) - specify if the input images are already in the cloud or need to be uploaded first from the local filesystem
- `path` - path to the input images, relative to the local/cloud root
- `name` - a unique name for the created job

Run the pipeline with images already in the cloud:
```
py main.py --path path/to/images --mode cloud
```

Run the pipeline with images on your local filesystem:
```
py main.py --path path/to/images --mode local
```

#### Cloud setup
To use infrastructure, please request the GCP service account key at `pawel.mist@gmail.com`.

1. Clone the repo
```
git clone https://github.com/GDSC-Delft-Dev/apa.git
```

2. Set the GCP service account environmental variable
```
export GCP_FA_PRIVATE_KEY=<key> (linux, mac)
set GCP_FA_PRIVATE_KEY=<key> (windows)
```

3. Trigger the pipeline

Manual triggers allow you to run the latest pipeline builds from the Artifact Registry with custom input data using Cloud Run.  You can run a job with either input data from your local file system or input data that already resides in the cloud.

```bash
cd src/backend
sudo chmod +x trigger.sh
./trigger.sh
```

The supported arguments for `trigger.sh` are:
- `l` - path to the local images
- `c` - path to the images on the cloud (Cloud Storage)
- `n` - a unique name for the pipeline job

Note that local inputs are first copied to a staging directory in Cloud Storage, and will only be removed if the job succeeeds.

Provide input data from a local filesystem

```bash
./trigger.sh -l /path/to/data/ -n name-of-the-job
```

Provide input data from Cloud Storage

```bash
./trigger.sh -c /path/to/data/ -n name-of-the-job
```

### Testing
To executed the automated tests, run `pytest` unit tests:

```
python -m pytest
```

### Static analysis
Our project uses `mypy` and `pylint` to assert the quality of the code. You can run these with:

```
python -m mypy . --explicit-package-bases
python -m pylint ./pipeline
```

### CI/CD
The CI/CD pushes the build from the latest commit to the `pipelines-dev` repository in the Google Artifact Registry. Note that only the backend is covered.

## Frontend setup
Please refer to `apa/src/frontend/README.md`.

## Contributing
Anyone who is eager to contribute to this project is very welcome to do so. Simply take the following steps:
1. Fork the project
2. Create your own feature branch
3. Commit your changes
4. Push to the `dev` branch and open a PR

## Datasets
You can play with the datasets in the `notebooks` folder.

## Build Tools

![image](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
</br>
![image](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
</br>
![image](https://img.shields.io/badge/Python-FFD43B?style=for-the-badge&logo=python&logoColor=blue)
</br>
![image](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black)
</br>
![image](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
</br>
![image](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
</br>
![image](https://img.shields.io/badge/OpenCV-27338e?style=for-the-badge&logo=OpenCV&logoColor=white)
</br>
![image](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)


## License
Distributed under the MIT License. See `LICENSE.txt` for more information.

## Contact
- Google Developers Student Club Delft - dsc.delft@gmail.com
- Paul Misterka - pawel.mist@gmail.com
- Mircea Lica - mirceatlx@gmail.com
- David Dinucu-Jianu - david.dinucujianu@gmail.com
- Nadine Kuo - kuonadine@gmail.com
<!-- Not sure if I shou -->
