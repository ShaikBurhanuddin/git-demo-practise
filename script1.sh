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
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

    # Add debugging information
    set -x

    # Set health check threshold
    HEALTH_CHECK_THRESHOLD=3
    consecutive_failures=0
    HEARTBEAT_INTERVAL=10  # Set the interval for heartbeat check in seconds

    while true; do
        CLUSTER_HEALTH=$(kubectl get componentstatuses --no-headers | awk '$2=="Healthy"{print $2}')

        if [ "$CLUSTER_HEALTH" == "Healthy" ]; then
            echo "AKS cluster is now running and healthy."
            break
        else
            ((consecutive_failures++))
            echo "AKS cluster is not healthy. Consecutive failures: $consecutive_failures"

            if [ $consecutive_failures -ge $HEALTH_CHECK_THRESHOLD ]; then
                echo "Health check failures exceeded the threshold. Taking corrective action..."
                # Add your corrective action here, e.g., restarting pods or triggering an alert.
                # Restarting all pods in a specific namespace
                kubectl delete pods --all -n default
                break
            fi
        fi

        echo "Waiting for the AKS cluster to be healthy..."
        sleep $HEARTBEAT_INTERVAL
    done

    # Stop debugging information
    set +x
else
    echo "AKS cluster is already running."
fi
