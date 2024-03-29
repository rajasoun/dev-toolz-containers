# aws-toolz-assembly

ARG BASE_IMAGE
ARG VERSION

FROM ${BASE_IMAGE}:1.0.0 as aws-toolz-assembly

# COPY Python Packages
COPY --from=rajasoun/dev-toolz-python-packages:1.0.0  /tmp/packages-tmp/    /tmp/packages-tmp/

RUN set -ex \
    && /tmp/packages-tmp/setup.sh

# COPY tools
COPY --from=rajasoun/dev-toolz-aws-vault:1.0.0                 /usr/local/bin/aws-vault                /usr/local/bin/aws-vault
COPY --from=rajasoun/dev-toolz-cloud-nuke:1.0.0                /usr/local/bin/cloud-nuke               /usr/local/bin/cloud-nuke
COPY --from=rajasoun/dev-toolz-aws-nuke:1.0.0                  /usr/local/bin/aws-nuke                 /usr/local/bin/aws-nuke
COPY --from=rajasoun/dev-toolz-aws-crawl:1.0.0                 /usr/local/bin/aws-crawl                /usr/local/bin/aws-crawl
COPY --from=rajasoun/dev-toolz-awless:1.0.0                    /usr/local/bin/awless                   /usr/local/bin/awless
COPY --from=rajasoun/dev-toolz-fetch:1.0.0                     /usr/local/bin/fetch                    /usr/local/bin/fetch
COPY --from=rajasoun/dev-toolz-syft:1.0.0                      /usr/local/bin/syft                     /usr/local/bin/syft
COPY --from=rajasoun/dev-toolz-terraform:1.0.0                 /usr/local/bin/terraform                /usr/local/bin/terraform
COPY --from=rajasoun/dev-toolz-terragrunt:1.0.0                /usr/local/bin/terragrunt               /usr/local/bin/terragrunt
COPY --from=rajasoun/dev-toolz-packer:1.0.0                    /usr/local/bin/packer                   /usr/local/bin/packer
COPY --from=rajasoun/dev-toolz-grype:1.0.0                     /usr/local/bin/grype                    /usr/local/bin/grype
COPY --from=rajasoun/dev-toolz-kubectl:1.0.0                   /usr/local/bin/kubectl                  /usr/local/bin/kubectl
COPY --from=rajasoun/dev-toolz-eksctl:1.0.0                    /usr/local/bin/eksctl                   /usr/local/bin/eksctl
COPY --from=rajasoun/dev-toolz-helm:1.0.0                      /usr/local/bin/helm                     /usr/local/bin/helm
COPY --from=rajasoun/dev-toolz-sentry:1.0.0                    /usr/local/bin/sentry-cli               /usr/local/bin/sentry-cli
COPY --from=rajasoun/dev-toolz-gh:1.0.0                        /usr/bin/gh                             /usr/local/bin/gh
COPY --from=rajasoun/dev-toolz-aws-iam-authenticator:1.0.0     /usr/local/bin/aws-iam-authenticator    /usr/local/bin/aws-iam-authenticator
COPY --from=rajasoun/dev-toolz-pulumi:1.0.0                    /root/.pulumi/bin/                      /usr/local/bin/

COPY --from=rajasoun/dev-toolz-sso:1.0.0                       /usr/local/bin/aws-sso                  /usr/local/bin/aws-sso
COPY --from=rajasoun/dev-toolz-sso:1.0.0                       /scripts/aws-sso-init.sh                /scripts/aws-sso-init.sh

COPY --from=rajasoun/dev-toolz-teller:1.0.0                    /usr/local/bin/teller                   /usr/local/bin/teller

COPY --from=rajasoun/dev-toolz-workspace-scripts:1.0.0          /workspaces                            /workspaces

# aws cli
RUN set -ex \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update \
    && aws --version

# Remove library scripts for final image
RUN set -ex \
    && apt-get --purge remove unzip -y \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/library-scripts \
    && rm -rf /tmp/packages-tmp \
    && rm -rf /tmp/*

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME
