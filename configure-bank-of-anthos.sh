#!/bin/zsh

## AWS ECR
#aws_account="100588478000"
#region="us-west-2"
#docker_repo="${aws_account}.dkr.ecr.${region}.amazonaws.com/bank-of-anthos/"

## GCP GAR
#region="us-east1"
#project_id="gke-project-01-05c8c7d8"
#docker-repo="${region}-docker.pkg.dev/${project_id}"

## GCP GCR
#region="us"
#project_id="gke-polygraph-demo"

source repositories.sh

source_repo=${boa_source_repo}
app_name=${boa_app_name}
app_version=${boa_app_version}

registry_type=${1:?"Please specify ECR, GAR, or GCR"} 

git clone git@github.com:GoogleCloudPlatform/bank-of-anthos.git

for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_METRICS/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file
for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e '/ENABLE_TRACING/ {n;s/true/false/;:p' -e 'n;bp' -e '}' $file

case ${registry_type} in
"ECR")
  docker_repo="${aws_account}.dkr.ecr.${aws_region}.amazonaws.com"
  ;;
"GAR")
  docker_repo="${gcp_gar_region}-docker.pkg.dev/${gcp_project_id}"
  ;;
"GCR")
  docker_repo="${gcp_gcr_region}gcr.io/${gcp_project_id}"
  ;;
esac 

for file in `ls bank-of-anthos/kubernetes-manifests/*.yaml`; sed -i.bak -e "s#${source_repo}#${docker_repo}#g" $file
# TODO: update manifests to display AWS if running in AWS

kubectl create namespace bankofanthos
kubectl apply -f bank-of-anthos/extras/jwt/jwt-secret.yaml -n bankofanthos
kubectl apply -f bank-of-anthos/kubernetes-manifests -n bankofanthos
