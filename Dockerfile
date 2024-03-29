FROM centos:centos7.2.1511

ENV RELEASE_TAG=1.70.0 \
    GOVERSION=1.19 \
    GOROOT=/home/go \
    GOPATH=/home/go-tools \
    GOPROXY=https://goproxy.cn,direct
ADD https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${RELEASE_TAG}/openvscode-server-v${RELEASE_TAG}-linux-x64.tar.gz /
ADD https://go.dev/dl/go${GOVERSION}.linux-amd64.tar.gz /

RUN tar xzf openvscode-server-v${RELEASE_TAG}-linux-x64.tar.gz && \
    tar xzf go${GOVERSION}.linux-amd64.tar.gz -C /home && \
    rm -f *.tar.gz && \
    mv /openvscode-server-v${RELEASE_TAG}-linux-x64 /openvscode
RUN yum -y update; exit 0

RUN yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    rpm --rebuilddb && \
    yum -y install make gcc git236
#     yum -y install make gcc git224 kde-l10n-Chinese && \
#     yum -y reinstall glibc-common && \
#     localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# LANG=zh_CN.utf8

EXPOSE 3000

ENTRYPOINT [ "/bin/sh", "-c", "exec openvscode/bin/openvscode-server --host 0.0.0.0 --without-connection-token \"${@}\"", "--" ]
