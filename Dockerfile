# # base
# FROM centos:latest
# # set the github runner version
# ARG RUNNER_VERSION="2.304.0"
# # update the base packages and add a non-sudo user
# RUN cd /etc/yum.repos.d/
# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
# RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# RUN yum update -y
# RUN yum install jq -y
# RUN yum groupinstall 'Development Tools' -y
# RUN yum install openssl-devel -y
# RUN yum install libffi-devel -y
# RUN yum install python3 -y
# RUN yum install python3-pip -y
# RUN yum install python3-virtualenv -y
# RUN yum install python3-devel -y
# RUN useradd -m docker
# RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
#     && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
#     && tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz
# RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
# COPY start.sh start.sh
# RUN chmod +x start.sh
# USER docker
# ENTRYPOINT ["./start.sh"]

FROM ubuntu:22.04

# RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list
RUN apt update && apt install -y \
    curl \
    git \
    nano
RUN apt-get install -y golang-go
RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list \
    && apt update \
    && apt install -y goreleaser

# RUN apt update && apt install -y \
#     git \
#     curl \
#     nano \
#     # goreleaser
#     golang

# RUN go install github.com/goreleaser/goreleaser@latest
# RUN goreleaser --version

RUN useradd -m docker
RUN cd /home/docker && mkdir actions-runner && cd actions-runner && \
    curl -o actions-runner-linux-arm64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-arm64-2.304.0.tar.gz && \
    echo "34c49bd0e294abce6e4a073627ed60dc2f31eee970c13d389b704697724b31c6  actions-runner-linux-arm64-2.304.0.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-arm64-2.304.0.tar.gz
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh
COPY setup.sh setup.sh
RUN chmod +x setup.sh
USER docker

ENTRYPOINT ["./setup.sh"]

# ENTRYPOINT ["./run.sh"]