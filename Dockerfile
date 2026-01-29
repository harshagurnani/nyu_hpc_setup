# FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim@sha256:f106758c361464e22aa1946c1338ae94de22ec784943494f26485d345dac2d85
FROM ghcr.io/astral-sh/uv:python3.10-bookworm@sha256:25f68c6c885934846b4a1906ec31b8af5a00e47f6dc0c90b9ff3e3efb70313e1

ENV UV_COMPILE_BYTECODE=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server \
    apt-utils \
    bash \
    build-essential \
    ca-certificates \
    curl \
    wget \
    git \
    gcc \
    nano \
    zip \
    unzip \
    net-tools \
    dnsutils \
    htop \
    lsof \
    strace \
    man \
    graphviz \
    pandoc \
    swig \
    gnupg \
    less \
    tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

SHELL ["/bin/bash", "-c"]

WORKDIR /workspace

COPY ./requirements.txt ./requirements.txt

RUN uv pip install --system --no-cache -r requirements.txt

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]