#!/bin/bash

# Assuming your AKS cluster name is stored in a variable
aks_cluster_name="burhanuddin-kuber"

# Check if the AKS cluster is already running
cluster_status=$(az aks show --name "$aks_cluster_name" --resource-group "nodejs-rg" --query 'provisioningState' -o tsv)

if [ "$cluster_status" == "Succeeded" ]; then
    echo "AKS cluster is already running."
else
    echo "Starting AKS cluster..."
    
    # Start the AKS cluster
    az aks start --name "$aks_cluster_name" --resource-group "nodejs-rg"
    
    # You may need to wait for the cluster to start if needed
    # Add your additional commands or logic here
    
    echo "AKS cluster started successfully."
fi