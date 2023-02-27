FROM python:3.10

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image
COPY . ./

# Install production dependencies.
RUN pip install --no-cache-dir -r requirements.txt
