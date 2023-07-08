FROM alpine:latest

#COPY --chown=root:root --chmod=777 ./test.sh /usr/local/bin/test.sh

# Install necessary tools
RUN apk add --no-cache wget unzip ca-certificates python3 py3-pip bash

# Install kubectl
RUN wget https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install AWS CLI
RUN pip3 install awscli

# Install Vault
ENV VAULT_VERSION="1.8.0"
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
    && chmod +x vault \
    && mv vault /usr/local/bin/

# Install Helm
ENV HELM_VERSION="3.6.3"
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && chmod +x linux-amd64/helm \
    && mv linux-amd64/helm /usr/local/bin/

# Install Terraform
ENV TERRAFORM_VERSION="0.14.9"
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && chmod +x terraform \
    && mv terraform /usr/local/bin/

# COPY --chown=root:root --chmod=777 ./test.sh /usr/local/bin/test.sh
# ENTRYPOINT ["/usr/local/bin/test.sh"]
CMD ["bash"]