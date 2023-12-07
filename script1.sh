#!/bin/bash

# Set your AKS cluster name and resource group
AKS_CLUSTER_NAME="mvn-spring"
RESOURCE_GROUP="cicd-mvn"

# Check if the AKS cluster is already running
CLUSTER_STATUS=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --query 'powerState.code' -o tsv)

if [ "$CLUSTER_STATUS" == "Stopped" ]; then
    # Start the AKS cluster
    echo "Starting AKS cluster..."
    az aks start --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP

    # Wait for the cluster to be in a ready state
    echo "Waiting for the AKS cluster to be ready..."

    # Add debugging information
    set -x

    while true; do
        CLUSTER_HEALTH=$(kubectl get componentstatuses --no-headers | awk '$2=="Healthy"{print $2}')

        if [ "$CLUSTER_HEALTH" == "Healthy" ]; then
            echo "AKS cluster is now running and healthy."
            break
        fi

        echo "Waiting for the AKS cluster to be healthy..."
        sleep 10
    done

    # Stop debugging information
    set +x
else
    echo "AKS cluster is already running."
fi