FROM centos:centos7.2.1511

ENV RELEASE_TAG=1.63.2 \
    GOVERSION=1.17.5 \
    GOROOT=/home/go \
    GOPATH=/home/go-tools \
    GOPROXY=https://goproxy.io

ADD https://github.com/gitpod-io/openvscode-server/releases/download/${RELEASE_TAG}/${RELEASE_TAG}-linux-x64.tar.gz /
# ADD openvscode-server-v${RELEASE_TAG}-linux-x64.tar.gz /

ADD https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz /home
# ADD go${GOVERSION}.linux-amd64.tar.gz /home

RUN mv /openvscode-server-v${RELEASE_TAG}-linux-x64 /openvscode && yum -y update; exit 0
RUN yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    rpm --rebuilddb && \
    yum -y install make gcc git224
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

EXPOSE 3000

ENTRYPOINT [ "/bin/sh", "-c", "exec openvscode/server.sh --port 3000 \"${@}\"", "--" ]