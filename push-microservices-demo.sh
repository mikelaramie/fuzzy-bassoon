#! /bin/zsh
#AWS
aws_account="100588478000"
aws_region="us-west-2"

#GCP
gcp_project_id="gke-polygraph-demo"
gcp_gar_region="us" 
gcp_gcr_region="us." # must end in . for regional GCR; leave blank for global `gcr.io`

# The version of images from https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml
source_repo="gcr.io/google-samples"
app_name="microservices-demo"
app_version="v0.3.6" 

registry_type=${1:?"Please specify ECR, GAR, or GCR"} 

for container (adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice ); do
docker pull ${source_repo}/${app_name}/${container}:${app_version}
#docker tag gcr.io/google-samples/microservices-demo/${container}:${version} ${aws_account}.dkr.ecr.${region}.amazonaws.com/microservices-demo/${container}:${version}
#docker tag gcr.io/google-samples/microservices-demo/${container}:${version} ${region}-docker.pkg.dev/${gcp_project}/online-boutique/${container}:${version}
#docker push ${aws_account}.dkr.ecr.${region}.amazonaws.com/microservices-demo/${container}:${version}
#docker push ${region}-docker.pkg.dev/${gcp_project}/online-boutique/${container}:${version}
case ${registry_type} in
"ECR")
  # AWS ECR
  aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account}.dkr.ecr.${region}.amazonaws.com
  aws ecr create-repository --repository-name ${app_name}/${container} --region ${region}
  docker tag ${source_repo}/${app_name}/${container}:${app_version} ${aws_account}.dkr.ecr.${region}.amazonaws.com/${app_name}/${container}:${app_version}
  docker push ${aws_account}.dkr.ecr.${region}.amazonaws.com/${app_name}/${container}:${app_version}
  ;;
"GAR")
  # GCP GAR
  docker tag ${source_repo}/${app_name}/${container}:${app_version} ${gcp_gar_region}-docker.pkg.dev/${gcp_project_id}/${app_name}/${container}:${app_version}
  docker push ${gcp_gar_region}-docker.pkg.dev/${gcp_project_id}/${app_name}/${container}:${app_version}
  ;;
"GCR")
  # GCP GCR
  docker tag ${source_repo}/${app_name}/${container}:${app_version} ${gcp_gcr_region}gcr.io/${gcp_project_id}/${app_name}/${container}:${app_version}
  docker push ${gcp_gcr_region}gcr.io/${gcp_project_id}/${app_name}/${container}:${app_version}
  ;;
esac

if [ "$2" = "--delete" ]; then
  docker rmi ${source_repo}/${app_name}/${container}:${app_version}
fi 

done
