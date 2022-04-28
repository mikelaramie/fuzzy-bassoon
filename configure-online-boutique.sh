#!/bin/zsh

source repositories.sh

source_repo=${ob_source_repo}
app_name=${ob_app_name}
app_version=${ob_app_version}

registry_type=${1:?"Please specify ECR, GAR, or GCR"} 


git clone git@github.com:GoogleCloudPlatform/microservices-demo.git

sed -i.bak -e '/DISABLE_/ s/# // ; /value: "1"/ s/# //' microservices-demo/release/kubernetes-manifests.yaml

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

sed -i.bak -e "s#${source_repo}#${docker_repo}#g" microservices-demo/release/kubernetes-manifests.yaml
# TODO: update manifests to display AWS if running in AWS
kubectl create namespace boutique
kubectl apply -f microservices-demo/release/kubernetes-manifests.yaml -n boutique
