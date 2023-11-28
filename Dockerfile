FROM jupyter/datascience-notebook:latest

USER root

### from https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.1.0/ubuntu2004/base/Dockerfile

ENV NVARCH x86_64

ENV NVIDIA_REQUIRE_CUDA "cuda>=12.1 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=510,driver<511 brand=unknown,driver>=510,driver<511 brand=nvidia,driver>=510,driver<511 brand=nvidiartx,driver>=510,driver<511 brand=geforce,driver>=510,driver<511 brand=geforcertx,driver>=510,driver<511 brand=quadro,driver>=510,driver<511 brand=quadrortx,driver>=510,driver<511 brand=titan,driver>=510,driver<511 brand=titanrtx,driver>=510,driver<511 brand=tesla,driver>=515,driver<516 brand=unknown,driver>=515,driver<516 brand=nvidia,driver>=515,driver<516 brand=nvidiartx,driver>=515,driver<516 brand=geforce,driver>=515,driver<516 brand=geforcertx,driver>=515,driver<516 brand=quadro,driver>=515,driver<516 brand=quadrortx,driver>=515,driver<516 brand=titan,driver>=515,driver<516 brand=titanrtx,driver>=515,driver<516 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526"
ENV NV_CUDA_CUDART_VERSION 12.1.55-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-12-1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 12.1.0

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-1=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

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

# ENV VSCODE_USER       vscode
# ENV VSCODE_PASSWORD   passwd
# ENV VSCODE_GROUP      vscode
# ENV VSCODE_HOME       /home/vscode
# ENV VSCODE_UID        1000
# ENV VSCODE_GID        1000
# ENV VSCODE_GRANT_SUDO nopass

ENV VSCODE_TUNNEL     vm
ENV VSCODE_PROVIDER   github

COPY ./entrypoint.sh /entrypoint.sh
COPY ./code.sh /code.sh

# RUN set -eux; \
#     chmod -R go+rx /etc/skel

# ENTRYPOINT ["/entrypoint.sh"]

USER jovyan

ENTRYPOINT ["/code.sh", "vm", "github"]

