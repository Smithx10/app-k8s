#!/bin/bash

env
# set k8s vars 
k8s_ver=${K8S_VER:-1.10.2}
k8s_pkg=kubernetes.tar.gz
k8s_sha256=${K8S_SHA256:-1ff377ad005a5548f872f7534328dcc332c683e527f432708eddcc549a6ab880}
k8s_url=https://github.com/kubernetes/kubernetes/releases/download/v${K8S_VER}/kubernetes.tar.gz

echo ${k8s_sha256}

# unpack k8s bins
curl -Ls --fail -o /tmp/${k8s_pkg} ${k8s_url}
echo "${k8s_sha256} /tmp/${k8s_pkg}" | sha256sum -c
tar zxvf /tmp/${k8s_pkg} -C /tmp
yes | /tmp/kubernetes/cluster/get-kube-binaries.sh
tar zxvf /tmp/kubernetes/server/kubernetes-server-linux-amd64.tar.gz -C /tmp
