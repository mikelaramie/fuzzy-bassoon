#! /bin/zsh
region="us-east1"
project_id="gke-project-01-05c8c7d8"
version="v0.5.0"

for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
docker pull gcr.io/bank-of-anthos/${container}:${version}
docker tag gcr.io/bank-of-anthos/${container}:${version} ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
docker push ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
done

