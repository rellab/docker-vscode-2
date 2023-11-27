From nvidia/cuda:12.2.2-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    git \
    locales \
    sudo \
    whois \
    dumb-init \
    vim \
    curl \
    wget \
    gdebi &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o /tmp/vscode.deb &&\
    gdebi /tmp/vscode.deb &&\
    rm /tmp/vscode.deb

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

