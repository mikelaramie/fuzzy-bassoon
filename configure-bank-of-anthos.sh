#!/bin/zsh

#region="us-east1"
#project_id="gke-project-01-05c8c7d8"
#docker-repo="${region-docker}.pkg.dev/${project_id}"
aws_account="100588478000"
region="us-west-2"
docker_repo="${aws_account}.dkr.ecr.${region}.amazonaws.com/bank-of-anthos/"


git clone git@github.com:GoogleCloudPlatform/bank-of-anthos.git

for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_METRICS/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file
for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_TRACING/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file
for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e "s#gcr.io/bank-of-anthos-ci/#${docker_repo}#g" $file

kubectl create namespace bankofanthos
kubectl apply -f bank-of-anthos/extras/jwt/jwt-secret.yaml -n bankofanthos
kubectl apply -f bank-of-anthos/kubernetes-manifests -n bankofanthos
