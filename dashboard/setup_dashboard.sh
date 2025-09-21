#!/bin/bash

## https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    --create-namespace \
    --namespace kubernetes-dashboard \
    --set kong.image.repository=kong \
    --set kong.image.tag="3.9.0"

## https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
# add admin-user and other resources
kubectl apply -f accounts.yaml

# generate token
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d
