#! /bin/zsh
#AWS
export aws_account="100588478000"
export aws_region="us-west-2"

#GCP
export gcp_project_id="gke-polygraph-demo"
export gcp_gar_region="us"
export gcp_gcr_region="us." # must end in . - TODO: add logic to add . when necessary

# The version of images from https://github.com/GoogleCloudPlatform/bank-of-anthos/tree/main/kubernetes-manifests
export boa_source_repo="gcr.io"
export boa_app_name="bank-of-anthos-ci"
export boa_app_version="v0.5.4" 

# The version of images from https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml
export ob_source_repo="gcr.io/google-samples"
export ob_app_name="microservices-demo"
export ob_app_version="v0.3.6" 
