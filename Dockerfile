FROM alpine

RUN apk add --no-cache tini bash ca-certificates curl wget

# Kubenetes CLI
ENV KUBERNETES_VERSION=1.30.2
RUN arch=$(uname -m) && \
    if [ "${arch}" = "x86_64" ]; then \
    arch="amd64"; \
    elif [ "${arch}" = "aarch64" ]; then \
    arch="arm64"; \
    fi && \
    curl -Lo kubectl https://dl.k8s.io/release/v${KUBERNETES_VERSION}/bin/linux/${arch}/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Helm CLI
ENV HELM_VERSION=3.15.2
RUN arch=$(uname -m) && \
    if [ "${arch}" = "x86_64" ]; then \
    arch="amd64"; \
    elif [ "${arch}" = "aarch64" ]; then \
    arch="arm64"; \
    fi && \
    curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${arch}.tar.gz | tar -zxf - --strip=1 linux-${arch}/helm && \
    mv helm /usr/local/bin/

ENV PS1="\w\$ "

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash"]