FROM alpine:latest

# Alpine packages
RUN apk --no-cache \
    add \
        gnupg \
        curl \
        bash \
        ca-certificates

ENV CONTAINERPILOT=/etc/containerpilot.json5

# Add jq
RUN export JQ_VER=1.5 \
    && export JQ_SHA256=c6b3a7d7d3e7b70c6f51b706a3b90bd01833846c54d32ca32f0027f00226ff6d \ 
    && export JQ_URL=https://github.com/stedolan/jq/releases/download/jq-${JQ_VER}/jq-linux64 \
    && curl -Ls --fail -o /usr/local/bin/jq ${JQ_URL} \
    && echo "${JQ_SHA256}  /usr/local/bin/jq" | sha256sum -c \
    && chmod +x /usr/local/bin/jq

# Add ran http web server
RUN export RAN_VER=0.1.3 \
    && export RAN_PKG=ran_linux_amd64.zip \
    && export RAN_URL=https://github.com/m3ng9i/ran/releases/download/v${RAN_VER}/${RAN_PKG} \
    && export RAN_SHA256=2e7cdbadf495e79993768bf37f51f8f704ae66e5cbcb96dd7a80996fdebcbbdf \
    && curl -Ls --fail -o /tmp/${RAN_PKG} ${RAN_URL} \
    && echo "${RAN_SHA256}  /tmp/${RAN_PKG}" | sha256sum -c \
    && unzip /tmp/${RAN_PKG} -d /usr/local/bin \
    && mv /usr/local/bin/ran_linux_amd64 /usr/local/bin/ran \
    && mkdir /ran \
    && rm /tmp/${RAN_PKG}

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
