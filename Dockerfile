FROM ubuntu:20.04

ENV RELEASE_TAG=1.70.0 \
    GOVERSION=1.18.5 \
    GOROOT=/home/go \
    GOPATH=/home/go-tools \
    GOPROXY=https://goproxy.cn,direct
ADD https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${RELEASE_TAG}/openvscode-server-v${RELEASE_TAG}-linux-x64.tar.gz /
ADD https://go.dev/dl/go${GOVERSION}.linux-amd64.tar.gz /

RUN tar xzf openvscode-server-v${RELEASE_TAG}-linux-x64.tar.gz && \
    tar xzf go${GOVERSION}.linux-amd64.tar.gz -C /home && \
    rm -f *.tar.gz && \
    mv /openvscode-server-v${RELEASE_TAG}-linux-x64 /openvscode

RUN apt-get update && apt-get -y install git make gcc

USER mrshell

ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# LANG=zh_CN.utf8

EXPOSE 3000

ENTRYPOINT [ "/bin/sh", "-c", "exec openvscode/bin/openvscode-server --host 0.0.0.0 --without-connection-token \"${@}\"", "--" ]
