#!/usr/bin/env bash

version=1.1.0

while getopts n: option
do
    case "${option}" in
        n) ACR=${OPTARG};;
    esac
done

if [[ "${ACR}" != "r1k8sacrdev" ]] && [[ "${ACR}" != "r1k8sacrtest" ]]; then
    echo "Unexpected container registry: ${ACR}.  Expect: r1k8sacrdev or r1k8sacrtest"
    exit 1
fi

echo "Logging into ${ACR} container registry."
az acr login -n ${ACR}

imageName=${ACR}.azurecr.io/metacontroller:v$version
echo "Building image $imageName from docker file"
docker build -t $imageName .
docker push $imageName