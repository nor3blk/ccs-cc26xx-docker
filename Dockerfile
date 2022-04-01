FROM ubuntu:18.04

ARG ver="11.1.0.00011"

ARG ccs="CCS${ver}_linux-x64"
ARG url="https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-J1VdearkvK/${ver}/${ccs}.tar.gz"
ARG setup_bin="ccs_setup_${ver}.run"

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
    --mode unattended \
 && cd .. && rm -rf ${ccs}

RUN apt remove -y wget curl \
 && apt autoremove -y \
 && apt autoclean \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="/home/ti/ccs/eclipse:${PATH}"

ENTRYPOINT ["/bin/bash"]
