#!/bin/zsh
registry="q5y5l4i3"

git clone git@github.com:GoogleCloudPlatform/microservices-demo.git

sed -i.bak -e '/DISABLE_/ s/# // ; /value: "1"/ s/# //' microservices-demo/release/kubernetes-manifests.yaml
sed -i.bak -e "s#gcr.io/google-samples/microservices-demo#public.ecr.aws/${registry}#g" microservices-demo/release/kubernetes-manifests.yaml

kubectl create namespace boutique
kubectl apply -f microservices-demo/release/kubernetes-manifests.yaml -n boutique
