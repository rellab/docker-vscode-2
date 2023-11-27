From nvidia/cuda:12.1.0-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
    net-tools \
    build-essential \
    git \
    locales \
    sudo \
    whois \
    dumb-init \
    vim \
    curl \
    wget \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libdbus-1-3 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3  \
    libpango-1.0-0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3  \
    libxkbcommon0 \
    libxkbfile1 \
    libxrandr2  \
    xdg-utils \
    libvulkan1 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o /tmp/vscode.deb &&\
    apt-get install -y /tmp/vscode.deb &&\
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

