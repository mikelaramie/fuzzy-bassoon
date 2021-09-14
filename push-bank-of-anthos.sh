#! /bin/zsh
region="us-east1"
project_id="mikelaramie-artifacts"
version="v0.5.0"

for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
docker pull gcr.io/bank-of-anthos/${container}:${version}
docker tag gcr.io/bank-of-anthos/${container}:${version} ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
docker push ${region}-docker.pkg.dev/${project_id}/bank-of-anthos/${container}:${version}
done

#for container (accounts-db balancereader contacts frontend ledger-db ledgerwriter loadgenerator transactionhistory userservice); do
#lw vuln ctr scan us-east1-docker.pkg.dev mikelaramie-artifacts/bank-of-anthos/${container} v0.5.0
#done
