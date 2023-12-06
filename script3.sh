#!/bin/bash

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