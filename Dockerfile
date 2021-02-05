FROM ubuntu:18.04

ARG ver="9.3.0.00012"

ARG ccs="CCS${ver}_linux-x64"
ARG url="https://software-dl.ti.com/ccs/esd/CCSv9/CCS_9_3_0/exports/${ccs}.tar.gz"
ARG setup_bin="ccs_setup_${ver}.bin"

LABEL maintainer="nor3blk"

RUN apt update \
 && dpkg --add-architecture i386

RUN apt update \
 && apt install -y libc6:i386 \
    libusb-0.1-4 \
    libgconf-2-4 \
    build-essential \
    wget curl \
    openjdk-8-jdk \
    openjdk-8-jdk-headless \
    libpython2.7 \
    git

RUN cd /home \
 && wget -nv $url \
 && tar zxf ${ccs}.tar.gz
RUN rm /home/${ccs}.tar.gz

RUN cd /home/${ccs} \
 && chmod a+x ${setup_bin} \
 && ./${setup_bin} --prefix /home/ti \
    --enable-components PF_CC2X \
    --mode unattended

ENV PATH="/home/ti/ccs/eclipse:${PATH}"

ENTRYPOINT ["/bin/bash"]
