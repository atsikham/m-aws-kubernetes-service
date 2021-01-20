FROM hashicorp/terraform:0.13.2 as initializer

COPY resources /resources
RUN cd /resources/terraform && terraform init

FROM hashicorp/terraform:0.13.2

ENV M_WORKDIR "/workdir"
ENV M_RESOURCES "/resources"
ENV M_SHARED "/shared"

ARG MAKE_VERSION=4.3-r0
ARG YQ_VERSION=3.3.4
ARG HELM_VERSION=3.3.4
ARG EKSCTL_VERSION=0.36.0

WORKDIR /workdir
ENTRYPOINT ["make"]

RUN apk add --update --no-cache make=${MAKE_VERSION} &&\
    wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq &&\
    # Installing helm
    wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz &&\
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz &&\
    mv linux-amd64/helm /usr/local/bin/helm &&\
    rm -rf linux-amd64 &&\
    chmod +x /usr/local/bin/helm &&\
    # Installing eksctl
    wget https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz &&\
    tar -zxvf eksctl_Linux_amd64.tar.gz &&\
    mv eksctl /usr/local/bin/eksctl &&\
    chmod +x /usr/local/bin/eksctl

ARG ARG_M_VERSION="unknown"
ENV M_VERSION=$ARG_M_VERSION

COPY --from=initializer /resources/ /resources/
COPY workdir /workdir

ARG ARG_HOST_UID=1000
ARG ARG_HOST_GID=1000
RUN chown -R $ARG_HOST_UID:$ARG_HOST_GID \
    $M_WORKDIR \
    $M_RESOURCES

USER $ARG_HOST_UID:$ARG_HOST_GID
# Set HOME to directory with necessary permissions for current user
ENV HOME=$M_WORKDIR

RUN helm repo add stable https://charts.helm.sh/stable
