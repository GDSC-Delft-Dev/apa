FROM python:3.10

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image
COPY . ./

# Solve ImportError: libGL.so.1: cannot open shared object file: No such file or directory"
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Install production dependencies.
RUN pip install --no-cache-dir -r requirements.txt