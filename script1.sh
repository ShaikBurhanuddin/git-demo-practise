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

    # Wait for the cluster to be in a ready state
    echo "Waiting for the AKS cluster to be ready..."
    az aks wait --resource-group cicd-mvn --name mvn-spring --updated --interval 30 --timeout 1800

    # Check the health status and heartbeat of the AKS cluster
    HEALTH_STATUS=$(az aks show --name mvn-spring --resource-group cicd-mvn --query 'agentPoolProfiles[0].provisioningState' -o tsv)
    
    if [ "$HEALTH_STATUS" == "Succeeded" ]; then
        echo "AKS cluster is running and healthy."
        
        # Connect to the AKS cluster control manager and scheduler
        echo "Connecting to AKS cluster..."
        az aks get-credentials --resource-group cicd-mvn --name mvn-spring

        # Add your commands to interact with the AKS cluster as needed
        kubectl get nodes
        kubectl get componentstatuses --no-headers
    else
        echo "AKS cluster health check failed. Please check the cluster status manually."
    fi
else
    echo "AKS cluster is already running."
fi
