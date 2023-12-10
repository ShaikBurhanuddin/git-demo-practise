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
  curl_result=$(curl -sS "http://$EXTERNAL_IP")
  
  # Print the result of the curl command
  echo "Curl Result: $curl_result"
fi


#script2
# Get the pod name

#POD_NAME=$(kubectl get pods -l app=nodejs-app -o jsonpath='{.items[0].metadata.name}')

#if [ -z "$POD_NAME" ]; then
#    echo "Error: Unable to find the pod."
#    exit 1
#fi

#echo "Pod name: $POD_NAME"

# Get LoadBalancer internal IP directly
#LB_INTERNAL_IP=$(kubectl get svc nodejs-service -o=jsonpath='{.spec.clusterIP}')

#if [ -z "$LB_INTERNAL_IP" ]; then
#    echo "Error: Unable to get LoadBalancer internal IP address."
#    exit 1
#fi

#echo "LoadBalancer internal IP: $LB_INTERNAL_IP"


# Execute the curl command directly inside the pod
#kubectl exec "$POD_NAME" -- sh -c "curl http://$LB_INTERNAL_IP:3001" > output.txt 2>&1

# Check the result
#if [ $? -ne 0 ]; then
#    echo "Error executing curl command in the pod."
#    exit 1
#fi

#echo "Curl command executed successfully."
#cat output.txt
# az aks stop --name mvn-spring --resource-group cicd-mvn