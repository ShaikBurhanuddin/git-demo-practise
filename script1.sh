#!/bin/bash

# Set your AKS cluster name and resource group
AKS_CLUSTER_NAME="mvn-spring"
RESOURCE_GROUP="cicd-mvn"

# Set timeouts and intervals
START_TIMEOUT=600   # 10 minutes
STOP_TIMEOUT=300    # 5 minutes
HEALTH_CHECK_INTERVAL=10
HEALTH_CHECK_THRESHOLD=3

function start_cluster() {
    echo "Starting AKS cluster..."
    az aks start --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP

    # Wait for the cluster to be in a ready state
    wait_for_cluster_ready $START_TIMEOUT
}

#function stop_cluster() {
#    echo "Stopping AKS cluster..."
#    az aks stop --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP

    # Wait for the cluster to be stopped
    wait_for_cluster_stopped $STOP_TIMEOUT
}

function wait_for_cluster_ready() {
    local timeout=$1
    local start_time=$(date +%s)

    while true; do
        CLUSTER_STATUS=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --query 'powerState.code' -o tsv)

        if [ "$CLUSTER_STATUS" == "Running" ]; then
            echo "AKS cluster is now running and healthy."
            break
        fi

        if [ $(( $(date +%s) - $start_time )) -ge $timeout ]; then
            echo "Timed out waiting for the AKS cluster to be ready."
            exit 1
        fi

        echo "Waiting for the AKS cluster to be ready..."
        sleep $HEALTH_CHECK_INTERVAL
    done
}

function wait_for_cluster_stopped() {
    local timeout=$1
    local start_time=$(date +%s)

    while true; do
        CLUSTER_STATUS=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --query 'powerState.code' -o tsv)

        if [ "$CLUSTER_STATUS" == "Stopped" ]; then
            echo "AKS cluster is now stopped."
            break
        fi

        if [ $(( $(date +%s) - $start_time )) -ge $timeout ]; then
            echo "Timed out waiting for the AKS cluster to be stopped."
            exit 1
        fi

        echo "Waiting for the AKS cluster to be stopped..."
        sleep $HEALTH_CHECK_INTERVAL
    done
}

# Check if the AKS cluster is already running
CLUSTER_STATUS=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --query 'powerState.code' -o tsv)

if [ "$CLUSTER_STATUS" == "Stopped" ]; then
    echo "start_cluster"
    az aks start --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP
   
    # Wait for the cluster to be in a ready state
    echo "Waiting for the AKS cluster to be ready..."
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

# Add debugging information
set -x

# Set health check threshold
HEALTH_CHECK_THRESHOLD=3
consecutive_failures=0

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
            break
        fi
    fi

    echo "Waiting for the AKS cluster to be healthy..."
    sleep $HEALTH_CHECK_INTERVAL
done

# Stop debugging information
set +x
else
    echo "AKS cluster is already running."
fi