#!/bin/bash

# Set your AKS cluster name and resource group
AKS_CLUSTER_NAME="burhanuddin-kuber"
RESOURCE_GROUP="nodejs-rg"

# Set the subscription ID
SUBSCRIPTION_ID="d038c3e3-1166-4425-a005-78d7ee94df8a"
az account set --subscription $SUBSCRIPTION_ID

# Check if the AKS cluster is already running
CLUSTER_STATUS=$(az aks show --name burhanuddin-kuber --resource-group nodejs-rg --query 'powerState.code' -o tsv)

if [ "$CLUSTER_STATUS" == "Stopped" ]; then
    # Start the AKS cluster
    echo "Starting AKS cluster..."
    az aks start --name burhanuddin-kuber --resource-group nodejs-rg
else
    echo "AKS cluster is already running."
fi
