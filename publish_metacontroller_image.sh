#!/usr/bin/env bash

source version.sh

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

echo "Building docker image into ${ACR}."
az acr build -r ${ACR} -t r1/c4/metacontroller:v${version} .
