#!/bin/bash

# Set your AKS cluster name and resource group
AKS_CLUSTER_NAME="mvn-spring"
RESOURCE_GROUP="cicd-mvn"

# Check if the AKS cluster is already running
CLUSTER_STATUS=$(az aks show --name mvn-spring --resource-group cicd-mvn --query 'powerState.code' -o tsv)

if [ "$CLUSTER_STATUS" == "Stopped" ]; then
    # Start the AKS cluster
    echo "Starting AKS cluster..."
    az aks start --name mvn-spring --resource-group cicd-mvn
else
    echo "AKS cluster is already running."
fi
