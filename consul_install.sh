#!/bin/bash

# set consul env vars
consul_ver=${CONSUL_VER:-1.1.0}
consul_pkg=consul_${consul_ver}_linux_amd64.zip
consul_url=https://releases.hashicorp.com/consul/${consul_ver}/${consul_pkg}
consul_sha256=$(curl https://releases.hashicorp.com/consul/${consul_ver}/consul_${consul_ver}_SHA256SUMS | grep linux_amd64 | awk '{print $1}')

# install consul 
curl -Ls --fail -o /tmp/${consul_pkg} ${consul_url}
echo "${consul_sha256} /tmp/${consul_pkg}" | sha256sum -c
unzip /tmp/${consul_pkg} -d /usr/local/bin
rm /tmp/${consul_pkg}
mkdir /etc/consul
mkdir /var/lib/consul
mkdir /data
mkdir /config
