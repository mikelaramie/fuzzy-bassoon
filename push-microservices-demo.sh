#! /bin/zsh
#aws_account="100588478000"
gcp_project="mikelaramie-artifacts-2"
region="us"
version="v0.3.5"

for container (adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice ); do
docker pull gcr.io/google-samples/microservices-demo/${container}:${version}
#docker tag gcr.io/google-samples/microservices-demo/${container}:${version} ${aws_account}.dkr.ecr.${region}.amazonaws.com/microservices-demo/${container}:${version}
docker tag gcr.io/google-samples/microservices-demo/${container}:${version} ${region}-docker.pkg.dev/${gcp_project}/online-boutique/${container}:${version}
#docker push ${aws_account}.dkr.ecr.${region}.amazonaws.com/microservices-demo/${container}:${version}
docker push ${region}-docker.pkg.dev/${gcp_project}/online-boutique/${container}:${version}

done
