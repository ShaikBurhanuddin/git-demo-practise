#!/bin/bash
# Get the current image tag from the file
IMAGE_TAG=$(cat /home/vsts/work/1/a/BuildID/BuildID/buildid.txt)
# Specify the path to your Kubernetes deployment YAML file
YAML_FILE="/home/vsts/work/1/s/deployment/deployment.yml"
# Replace the image tag in the YAML file
sed -i "s|image: mvnrepo.azurecr.io/nodejs:.*$|image: mvnrepo.azurecr.io/nodejs:${IMAGE_TAG}|g" $YAML_FILE

echo "Image tag changed to ${IMAGE_TAG}"