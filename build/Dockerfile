# Container containing all dependencies required for executing unit test on 'indy-node' Python module.
# Based upon / inspired by work of the indy-node docker working group of the ID Union project.
# see https://github.com/IDunion/indy-node-container/blob/main/build/Dockerfile.ubuntu18
#
# Intended use: docker run --mount src=[local path of indy-node repo],target=/home/indy/indy-node,type=bind [IMAGE] ./exec_tests.sh [ARGS]

FROM ubuntu:18.04 AS base

# Install environment
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    git \
    wget \
    python3.6 \
    python3-pip \
    python3-nacl \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    libsodium-dev \
    libsecp256k1-dev \
    libssl-dev \
    liblzma-dev \
    libsnappy-dev \
    liblz4-dev \
    libbz2-dev \
    zlib1g-dev \
    librocksdb-dev \
    software-properties-common \
    && apt-get autoremove -y
RUN pip3 install -U \
    'pip<10.0.0'

#    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial master" && \

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/deb xenial master" && \
    apt-get update && \
        apt-get install -y ursa

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu xenial main universe" && \
    apt-get install -y libsodium18
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable " && \
    apt-get update && \
    apt-get install -y libindy
    
FROM base AS builder

# deprecated dependencies based on libssl1.0 / libiny-crypto
RUN \
    # for old libssl needed for libindy-crypto
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 && \
    add-apt-repository "deb http://security.ubuntu.com/ubuntu bionic-security main" && \
    # for libindy-crypto
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable " && \
    apt-get update && \
    apt-get install -y libssl1.0.0 libindy-crypto=0.4.5 python3-indy-crypto=0.4.5

# RUN pip install python3-indy indy-node==1.12.4 indy-plenum==1.12.4
RUN pip install python3-indy indy-plenum==1.12.4

# FROM base AS builder

FROM base

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
            python3.6 \
            python3-pip \
            libsodium23 \
            librocksdb5.8 \
    && \
    apt-get autoremove -y

COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/lib/ /usr/local/lib/
COPY --from=builder /usr/lib/libindy* /usr/lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libssl* /usr/lib/x86_64-linux-gnu/libcrypto* /usr/lib/x86_64-linux-gnu/

RUN useradd -ms /bin/bash indy
WORKDIR /home/indy

COPY exec_tests.sh ./
VOLUME /home/indy/indy-node
VOLUME /home/indy/indy-plenum

# When started, execute all test within folder 'indy_node'  
CMD ["./exec_tests.sh", "indy_node"]