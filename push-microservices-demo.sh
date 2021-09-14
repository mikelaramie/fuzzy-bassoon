#! /bin/zsh
registry="q5y5l4i3"
version="v0.2.4"

for container (adservice cartservice checkoutservice currencyservice emailservice frontend loadgenerator paymentservice productcatalogservice recommendationservice shippingservice ); do
docker pull gcr.io/google-samples/microservices-demo/${container}:${version}
docker tag gcr.io/google-samples/microservices-demo/${container}:${version} public.ecr.aws/${registry}/${container}:${version}
docker push public.ecr.aws/${registry}/${container}:${version}
done
