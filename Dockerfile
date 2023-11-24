FROM ubuntu:22.04 AS mediainfo

RUN apt update && \
    apt-get install -y \
    git \
    automake \
    autoconf \
    libtool \
    pkg-config \
    make \
    g++ \
    zlib1g-dev

ARG ZENLIB_VERSION=0.4.41
ARG MEDIAINFO_VERSION=23.09

RUN git clone --branch v${ZENLIB_VERSION} --depth 1 https://github.com/MediaArea/ZenLib.git
RUN cd ZenLib/Project/GNU/Library && \
    ./autogen.sh && \
    ./configure --enable-static --disable-shared && \
    make install

RUN git clone --branch v${MEDIAINFO_VERSION} --depth 1 https://github.com/MediaArea/MediaInfoLib.git && \
    cd MediaInfoLib/Project/GNU/Library && \
    ./autogen.sh && \
    ./configure --enable-static --disable-shared && \
    make install

RUN git clone --branch v${MEDIAINFO_VERSION} --depth 1 https://github.com/MediaArea/MediaInfo.git
RUN cd MediaInfo/Project/GNU/CLI && \
    ./autogen.sh && \
    ./configure --enable-staticlibs --enable-static LDFLAGS=-static-libstdc++ && \
    make install
