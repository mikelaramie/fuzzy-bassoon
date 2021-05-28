#!/bin/zsh

git clone git@github.com:GoogleCloudPlatform/bank-of-anthos.git

for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_METRICS/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file

for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_TRACING/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file

kubectl create namespace bankofanthos
kubectl apply -f bank-of-anthos/extras/jwt/jwt-secret.yaml -n bankofanthos
kubectl apply -f bank-of-anthos/kubernetes-manifests -n bankofanthos
