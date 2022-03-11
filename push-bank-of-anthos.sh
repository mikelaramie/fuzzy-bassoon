#! /bin/zsh
aws_account="100588478000"
region="us-west-2"
#project_id="mikelaramie-artifacts"
version="v0.5.3"

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account}.dkr.ecr.${region}.amazonaws.com

for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
docker pull gcr.io/bank-of-anthos-ci/${container}:${version}
aws ecr create-repository --repository-name bank-of-anthos/${container} --region ${region}
docker tag gcr.io/bank-of-anthos-ci/${container}:${version} ${aws_account}.dkr.ecr.${region}.amazonaws.com/bank-of-anthos/${container}:${version}
#docker tag gcr.io/bank-of-anthos/${container}:${version} ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
docker push ${aws_account}.dkr.ecr.${region}.amazonaws.com/bank-of-anthos/${container}:${version}
#docker push ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
done

#for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
#lw vuln ctr scan us-east1-docker.pkg.dev mikelaramie-artifacts/bank-of-anthos/${container} v0.5.0
#done

# TODO:  Add docker rmi logic
