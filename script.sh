#!/bin/bash

# Replace 'your-service-name' with the actual name of your LoadBalancer service
SERVICE_NAME="nodejs-service"

# az account set --subscription 7338b8ab-3b46-420e-becc-da044eebe12c
az aks get-credentials --resource-group cicd-mvn --name mvn-spring

# Get the external IP address of the LoadBalancer service
EXTERNAL_IP=$(kubectl get services "$SERVICE_NAME" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$EXTERNAL_IP" ]; then
  echo "External IP not available yet. Please wait for the LoadBalancer to provision an external IP."
else
  echo "External IP Address: $EXTERNAL_IP"
  
  # Use curl to make a request to the service using the external IP
  curl_result=$(curl -sS "http://$EXTERNAL_IP:3001")
  
  # Print the result of the curl command
  echo "Curl Result: $curl_result"
fi

# az aks stop --name mvn-spring --resource-group cicd-mvn


# Get the pod name
POD_NAME=$(kubectl get pods -l app=nodejs-app -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD_NAME" ]; then
    echo "Error: Unable to find the pod."
    exit 1
fi

echo "Pod name: $POD_NAME"

# Execute a Bash command inside the pod to get LoadBalancer internal IP address
LB_INTERNAL_IP=$(kubectl get svc nodejs-service -o=jsonpath='{.spec.clusterIP}')
#LB_INTERNAL_IP=$(kubectl exec -it $POD_NAME -- bash -c "echo \$(kubectl get svc nodejs-service -o=jsonpath='{.spec.clusterIP}')")

if [ -z "$LB_INTERNAL_IP" ]; then
    echo "Error: Unable to get LoadBalancer internal IP address."
    exit 1
fi

echo "LoadBalancer internal IP: $LB_INTERNAL_IP"
#kubectl exec -it "$POD_NAME" bash

# Use the LoadBalancer internal IP for a curl command
curl_command="curl http://$LB_INTERNAL_IP:3001"
#curl http://$LB_INTERNAL_IP:3001

echo "Execute curl command: $curl_command"
#$curl_command
# Execute a Bash shell inside the pod
kubectl exec -it "$POD_NAME" -- bash -c "$curl_command"