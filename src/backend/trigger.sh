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

# create the actual job:
# JOB_NAME: the name of the job you want to create
# IMAGE_URL: reference to a container image from the Artifact Registry
# OPTIONS (any of the following): 
#               --tasks: 	Accepts integers greater or equal to 1
#               --max-retries: The number of times a failed task is retried
#               --task-timeout: Accepts a duration like "2s". Defaults to 10 minutes; maximum is 1h. 
#               --parallelism: The maximum number of tasks that can execute in parallel.
#               --execute-now: If set, immediately after the job is created, a job execution is started. 
#


while getopts ":l:c:v:n:" opt; do
  case $opt in
    l) local_source="$OPTARG"
    ;;
    c) cloud_source="$OPTARG"
    ;;
    v) VERSION="$OPTARG"
    ;;
    n) job_name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

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


if [ -n "$local_source" ]; then
  uuid=$(uuidgen)
  uuid=$(echo "$uuid" | tr '[:upper:]' '[:lower:]')
  echo "Created UUID for the local input data: $uuid"
  gsutil -m cp -r $local_source gs://terrafarm-inputs/$uuid/
  IFS='/' read -ra my_list <<< "$local_source"
  last_folder=$(echo $local_source | rev | cut -d/ -f2 | rev)
  cloud_path="$uuid/$last_folder"
  mode="local"

fi

if [ -n "$cloud_source" ]; then
  cloud_path=$cloud_source
  mode="cloud"
fi

parse_path="--path $cloud_path"
parse_mode="--mode $mode"

gcloud beta run jobs create $job_name --image $VERSION --command=python,main.py --args="$parse_path","$parse_mode"
echo "Job $job_name created"
# execute job

gcloud beta run jobs execute $job_name

echo "Job $job_name finished" 
