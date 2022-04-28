#! /bin/zsh
source repositories.sh

source_repo=${boa_source_repo}
app_name=${boa_app_name}
app_version=${boa_app_version}

registry_type=${1:?"Please specify ECR, GAR, or GCR"} 

for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
docker pull ${source_repo}/${app_name}/${container}:${app_version}

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

#for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
#lw vuln ctr scan us-east1-docker.pkg.dev mikelaramie-artifacts/bank-of-anthos/${container} v0.5.0
#done

