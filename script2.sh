#!/bin/bash
#script1
# Replace 'your-service-name' with the actual name of your LoadBalancer service
SERVICE_NAME="ingress-nginx-controller"

# az account set --subscription 7338b8ab-3b46-420e-becc-da044eebe12c
az aks get-credentials --resource-group cicd-mvn --name mvn-spring

# Get the external IP address of the LoadBalancer service
EXTERNAL_IP=$(kubectl get services "$SERVICE_NAME" -n ingress-basic -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$EXTERNAL_IP" ]; then
  echo "External IP not available yet. Please wait for the LoadBalancer to provision an external IP."
else
  echo "External IP Address: $EXTERNAL_IP"
  
  # Use curl to make a request to the service using the external IP
  curl_result=$(curl -sS "http://$EXTERNAL_IP:80")
  
  # Print the result of the curl command
  echo "Curl Result: $curl_result"
fi
# az aks stop --name mvn-spring --resource-group cicd-mvn