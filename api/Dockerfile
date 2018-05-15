# we don't want to use quay.io/coreos/etcd because they only ship the `etcd` and
# `etcdctl` binaries in a scratch container
FROM alpine:latest

ENV CONTAINERPILOT=/etc/containerpilot.json5

RUN apk --no-cache \
    add \
        bash \
        ca-certificates \
        curl \
        jq \
        util-linux

# Add cfssl
RUN export CFSSL_VER=1.2 \
  && export CFSSL_PKG=cfssl_linux-amd64 \
  && export CFSSL_SHA256=$(curl -L https://pkg.cfssl.org/R${CFSSL_VER}/SHA256SUMS | grep ${CFSSL_PKG} | awk '{print $1}') \
  && export CFSSL_URL=https://pkg.cfssl.org/R${CFSSL_VER}/${CFSSL_PKG} \
  && curl -Ls --fail -o /tmp/${CFSSL_PKG} ${CFSSL_URL} \
  && echo "${CFSSL_SHA256}  /tmp/${CFSSL_PKG}" | sha256sum -c \
  && mv /tmp/${CFSSL_PKG} /usr/local/bin/cfssl

RUN export CFSSJS_VER=1.2 \
  && export CFSSJS_PKG=cfssljson_linux-amd64 \
  && export CFSSJS_SHA256=$(curl -L https://pkg.cfssl.org/R${CFSSJS_VER}/SHA256SUMS | grep ${CFSSJS_PKG} | awk '{print $1}') \
  && export CFSSJS_URL=https://pkg.cfssl.org/R${CFSSJS_VER}/${CFSSJS_PKG} \
  && curl -Ls --fail -o /tmp/${CFSSJS_PKG} ${CFSSJS_URL} \
  && echo "${CFSSJS_SHA256}  /tmp/${CFSSJS_PKG}" | sha256sum -c \
  && mv /tmp/${CFSSJS_PKG} /usr/local/bin/cfssljson

# Add ContainerPilot and set its configuration
RUN export CP_VER=3.8.0 \
    && export CP_PKG=containerpilot-${CP_VER}.tar.gz \
    && export CP_SHA1=$(curl -L https://github.com/joyent/containerpilot/releases/download/${CP_VER}/containerpilot-${CP_VER}.sha1.txt | awk '{print $1}') \
    && export CP_URL=https://github.com/joyent/containerpilot/releases/download/${CP_VER}/${CP_PKG} \
    && curl -Ls --fail -o /tmp/${CP_PKG} ${CP_URL} \
    && echo "${CP_SHA1}  /tmp/${CP_PKG}" | sha1sum -c \
    && tar zxf /tmp/${CP_PKG} -C /usr/local/bin \
    && rm /tmp/${CP_PKG}

# Add Consul and set its configuration
RUN export CONSUL_VER=1.1.0 \
    && export CONSUL_PKG=consul_${CONSUL_VER}_linux_amd64.zip \
    && export CONSUL_URL=https://releases.hashicorp.com/consul/${CONSUL_VER}/${CONSUL_PKG} \
    && export CONSUL_SHA256=$(curl https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_SHA256SUMS | grep linux_amd64 | awk '{print $1}') \
    && curl -Ls --fail -o /tmp/${CONSUL_PKG} ${CONSUL_URL} \
    && echo "${CONSUL_SHA256}  /tmp/${CONSUL_PKG}" | sha256sum -c \
    && unzip /tmp/${CONSUL_PKG} -d /usr/local/bin \
    && rm /tmp/${CONSUL_PKG} \
    && mkdir /etc/consul \
    && mkdir /var/lib/consul \
    && mkdir /data \
    && mkdir /config


#COPY etc/etcd.json etc/etcd/
COPY ./etcd/bin/* /usr/local/bin/
COPY ./etcd/etc/containerpilot.json5 /etc/containerpilot.json5

ENV SHELL /bin/bash
