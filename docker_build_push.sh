#!/bin/bash

docker_build_push() {
  local REPOSITORY=$1
  local IMAGE_TAG=$2
  echo -e "\The Docker build will start in the repository ${REPOSITORY} with the tag ${IMAGE_TAG}."
  docker build -t ${REPOSITORY}:${IMAGE_TAG} .
  docker tag ${REPOSITORY}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY}:${IMAGE_TAG}
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY}:${IMAGE_TAG}
}

REPOSITORY=""
AWS_REGION=""
IMAGE_TAG=""
CURRENT_DATE=$(date)

for arg in "$@"; do
    case $arg in  
        repository=*)
        REPOSITORY="${arg#*=}"
        shift
        ;;
        aws_region=*)
        AWS_REGION="${arg#*=}"
        shift
        ;;        
        image_tag=*)
        IMAGE_TAG="${arg#*=}"
        shift
        ;;
        *)
        ;;
    esac
done

REPOSITORY=$(echo "$REPOSITORY" | tr '[:upper:]' '[:lower:]')

if [[ " ${REPOSITORY} " == "" ]]; then
    echo -e "\n----> Please specify a value for repository"
    echo -e "* ${CURRENT_DATE} - ERROR: repository is empty\n"
    exit 1
fi

AWS_REGION=$(echo "$AWS_REGION" | tr '[:upper:]' '[:lower:]')

if [[ " ${AWS_REGION} " == "" ]]; then
    echo -e "\n----> Please specify a region. eg aws_region=us-east-1"
    echo -e "* ${CURRENT_DATE} - ERROR: aws_region is empty\n"
    exit 1
fi

if [[ ! " ${IMAGE_TAG} " == "" ]]; then
    IMAGE_TAG="0.1"
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

for first_number in {0..10}; do
  for second_number in {0..9}; do
    IMAGE_TAG="${major}.${minor}"
    if ! aws ecr describe-images --repository-name ${REPOSITORY} --image-ids imageTag=${IMAGE_TAG} >/dev/null 2>&1; then
      docker_build_push ${REPOSITORY} ${IMAGE_TAG}
      exit 0
    fi
  done
done

echo -e "\n* ${CURRENT_DATE} - ERROR: No available tags found for range 0.1 to 10.9"
exit 1
