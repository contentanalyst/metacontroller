#!/usr/bin/env bash

source version.sh
chartFile=metacontroller-${version}.tgz

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

echo "Add ${ACR} as a helm repo."
az acr helm repo add -n ${ACR}

echo "Publishing helm chart ${chartFile} to ${ACR} container registry..."
helm package chart --version ${version}
az acr helm push ${chartFile} -n ${ACR}
