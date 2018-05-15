FROM alpine:latest

# Alpine packages
RUN apk --no-cache \
    add \
        gnupg \
        curl \
        bash \
        ca-certificates

ENV CONTAINERPILOT=/etc/containerpilot.json5

# The Vault binary
# Add Vault and set its configuration
RUN export VAULT_VER=0.10.1 \
    && export VAULT_PKG=vault_${VAULT_VER}_linux_amd64.zip \
    && export VAULT_URL=https://releases.hashicorp.com/vault/${VAULT_VER}/${VAULT_PKG} \
    && export VAULT_SHA256=$(curl https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_SHA256SUMS | grep linux_amd64 | awk '{print $1}') \
    && curl -Ls --fail -o /tmp/${VAULT_PKG} ${VAULT_URL} \
    && echo "${VAULT_SHA256}  /tmp/${VAULT_PKG}" | sha256sum -c \
    && unzip /tmp/${VAULT_PKG} -d /usr/local/bin \
    && rm /tmp/${VAULT_PKG} \
    && mkdir /etc/vault \
    && mkdir /var/lib/vault \
    && mkdir /data \
    && mkdir /config

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
    && mkdir /var/lib/consul 

# Add Containerpilot and set its configuration
RUN export CP_VER=3.8.0 \
    && export CP_PKG=containerpilot-${CP_VER}.tar.gz \
    && export CP_SHA1=$(curl -L https://github.com/joyent/containerpilot/releases/download/${CP_VER}/containerpilot-${CP_VER}.sha1.txt | awk '{print $1}') \
    && export CP_URL=https://github.com/joyent/containerpilot/releases/download/${CP_VER}/${CP_PKG} \
    && curl -Ls --fail -o /tmp/${CP_PKG} ${CP_URL} \
    && echo "${CP_SHA1}  /tmp/${CP_PKG}" | sha1sum -c \
    && tar zxf /tmp/${CP_PKG} -C /usr/local/bin \
    && rm /tmp/${CP_PKG}

# configuration files and bootstrap scripts
COPY ./vault/etc/containerpilot.json5 /etc/
COPY ./vault/etc/vault-no-tls.hcl /etc/
COPY ./vault/bin/* /usr/local/bin/

ENV SHELL /bin/bash
