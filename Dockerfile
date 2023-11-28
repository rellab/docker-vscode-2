From nvidia/cuda:12.0.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    git \
    gnupg \
    locales \
    sudo \
    whois \
    dumb-init \
    vim \
    curl \
    wget &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg &&\
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    code &&\
    apt-get clean &&\
    rm -fr /var/lib/apt/lists/*

RUN set -eux; \
    sed -i -E 's/# (en_US.UTF-8)/\1/' /etc/locale.gen; \
    locale-gen
ENV LANG       en_US.UTF-8
ENV LANGUAGE   en_US:en
ENV LC_ALL     en_US.UTF-8

ENV VSCODE_USER       vscode
ENV VSCODE_PASSWORD   passwd
ENV VSCODE_GROUP      vscode
ENV VSCODE_HOME       /home/vscode
ENV VSCODE_UID        1000
ENV VSCODE_GID        1000
ENV VSCODE_GRANT_SUDO nopass

ENV VSCODE_TUNNEL     vm
ENV VSCODE_PROVIDER   github

COPY ./entrypoint.sh /entrypoint.sh
COPY ./code.sh /code.sh

RUN set -eux; \
    chmod -R go+rx /etc/skel

ENTRYPOINT ["/entrypoint.sh"]

