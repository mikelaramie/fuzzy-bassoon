#!/bin/zsh

git clone git@github.com:GoogleCloudPlatform/microservices-demo.git

kubectl create namespace boutique
kubectl apply -f ./release/kubernetes-manifests.yaml -n boutique
