FROM alpine:latest

# Alpine packages
RUN apk --no-cache \
    add \
        curl \
        bash \
        ca-certificates

ENV CONTAINERPILOT=/etc/containerpilot.json5

# The Consul binary
# Add Consul and set its configuration
RUN export CONSUL_VER=1.1.0 \
    && export CONSUL_PKG=consul_${CONSUL_VER}_linux_amd64.zip \
    && export CONSUL_URL=https://releases.hashicorp.com/consul/${CONSUL_VER}/${CONSUL_PKG} \
    && export CONSUL_SHA256=$(curl https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_SHA256SUMS | grep linux_amd64 | awk '{print $1}') \
    && curl -Ls --fail -o /tmp/${CONSUL_PKG} ${CONSUL_URL} \
    && echo "${CONSUL_SHA256}  /tmp/${CONSUL_PKG}" | sha256sum -c \
    && unzip /tmp/${CONSUL_PKG} -d /bin \
    && rm /tmp/${CONSUL_PKG} \
    && mkdir /etc/consul \
    && mkdir /var/lib/consul \
    && mkdir /data \
    && mkdir /config

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
COPY etc/containerpilot.json5 etc/
COPY etc/consul.hcl etc/consul/
COPY bin/* /usr/local/bin/

# We don't need to expose these ports in order for other containers on Triton
# to reach this container in the default networking environment, but if we
# leave this here then we get the ports as well-known environment variables
# for purposes of linking.
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp

#ENV GOMAXPROCS 2
ENV SHELL /bin/bash
