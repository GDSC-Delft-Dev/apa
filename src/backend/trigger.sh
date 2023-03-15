#!/bin/bash
#
# Enable manual Google Cloud Run triggers for specific inputs 

# install requirements

gcloud components install beta

PROJECT="terrafarm-378218"
REGION="europe-west4"
REPO="pipelines-dev"
IMAGE="latest"

VERSION=$(gcloud artifacts docker images list \
${REGION}-docker.pkg.dev/${PROJECT}/${REPO} \
--filter="package=${REGION}-docker.pkg.dev/${PROJECT}/${REPO}/${IMAGE}" \
--sort-by="~UPDATE_TIME" \
--limit=1 \
--format="value(format("{0}@{1}",package,version))")

echo "Latest artifact image $VERSION"

# use getopts to parse options in the command line
while getopts ":l:c:v:n:" opt; do
  # for each argument, check if its in the list of supported arguments or not
  case $opt in
    # local argument
    l) local_source="$OPTARG"
    ;;
    # cloud argument
    c) cloud_source="$OPTARG"
    ;;
    # artifact image version (default latest)
    v) VERSION="$OPTARG"
    ;;
    # custom name for the job
    n) job_name="$OPTARG"
    ;;
    # the argument is not supported
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  # return exit code 1 if one of the arguments is not supported
  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

echo "$local_source"

# check if both local source and cloud source have been specified
if [[ -n "$local_source" && -n "$cloud_source" ]]; then 
  echo "You specified both local source and cloud source. You should onky specify one."
  exit 1
fi


# input images are taken from the local filesystem and uploaded to the cloud
if [ -n "$local_source" ]; then
  # create uuid for the input path in specified bucket
  uuid=$(uuidgen)
  # make sure all characters are lower-case
  uuid=$(echo "$uuid" | tr '[:upper:]' '[:lower:]')
  echo "Created UUID for the local input data: $uuid"
  # copy the data from a local path to the cloud
  gsutil -m cp -r $local_source gs://terrafarm-inputs/$uuid/
  IFS='/' read -ra my_list <<< "$local_source"
  # take the last folder from the local path to complete cloud path
  last_folder=$(echo $local_source | rev | cut -d/ -f2 | rev)
  # full cloud path without bucket name
  cloud_path="$uuid/$last_folder"
  # specify mode of operation
  mode="local"

fi

# input images directly from a cloud bucket
if [ -n "$cloud_source" ]; then
  cloud_path=$cloud_source
  mode="cloud"
fi

parse_path="--path $cloud_path"
parse_mode="--mode $mode"

# create job with custom arguments
gcloud beta run jobs create $job_name --image $VERSION --command=python,main.py --args="$parse_path","$parse_mode"
echo "Job $job_name created"
# execute job

# run created job
gcloud beta run jobs execute $job_name

echo "Job $job_name finished" 