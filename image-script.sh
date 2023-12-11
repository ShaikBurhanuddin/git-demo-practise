#!/bin/bash

# Get the current image tag from the file
imagetag=$(cat /home/vsts/work/1/a/BuildID/BuildID/buildid.txt)

# Specify the path to your Kubernetes deployment YAML file
yaml_file="/home/vsts/work/12/s/deployment/deployment.yml"

# Replace the image tag in the YAML file
sed -i "s|image: mvnrepo.azurecr.io/nodejs:.*$|image: mvnrepo.azurecr.io/nodejs:${imagetag}|g"  $yaml_file

echo "Image tag changed to ${imagetag}"
