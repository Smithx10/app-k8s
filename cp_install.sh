#!/bin/bash

# set containerpilot vars 
cp_ver=${CP_VER:-3.8.0}
cp_pkg=containerpilot-${cp_ver}.tar.gz
cp_sha1=$(curl -L https://github.com/joyent/containerpilot/releases/download/${cp_ver}/containerpilot-${cp_ver}.sha1.txt | awk '{print $1}')
cp_url=https://github.com/joyent/containerpilot/releases/download/${cp_ver}/${cp_pkg} 

# install containerpilot 
curl -Ls --fail -o /tmp/${cp_pkg} ${cp_url}
echo "${cp_sha1} /tmp/${cp_pkg}" | sha1sum -c
tar zxf /tmp/${cp_pkg} -C /usr/local/bin
rm /tmp/${cp_pkg}
