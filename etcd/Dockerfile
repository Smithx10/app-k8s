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

# Add EtcD and set its configuration

RUN export ETCD_VER=3.3.5 \
    && export ETCD_PKG=etcd-v${ETCD_VER}-linux-amd64.tar.gz \
    && export ETCD_SHA256=9eed277af462085b7354b9c0b3fbb2453b62bb116361d2025f6c150eae6e77c8 \
    && export ETCD_URL=https://github.com/coreos/etcd/releases/download/v${ETCD_VER}/${ETCD_PKG} \
    && curl -Ls --fail -o /tmp/${ETCD_PKG} ${ETCD_URL} \
    && echo "${ETCD_SHA256}  /tmp/${ETCD_PKG}" | sha256sum -c \
    && tar zxf /tmp/${ETCD_PKG} -C /usr/local/bin \
    && mv /usr/local/bin/etcd-v3.3.5-linux-amd64/etcdctl /usr/local/bin/etcdctl \
    && mv /usr/local/bin/etcd-v3.3.5-linux-amd64/etcd /usr/local/bin/etcd \
    && rm /tmp/${ETCD_PKG}

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
COPY ./bin/* /usr/local/bin/
COPY ./etc/containerpilot.json5 /etc/containerpilot.json5



EXPOSE 2379 2380 4001

ENV SHELL /bin/bash
