FROM ghcr.io/runatlantis/atlantis:v0.19.7

ARG terragrunt_version=v0.38.7
ARG terragrunt_atlantis_config_version=1.15.0

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/${terragrunt_version}/terragrunt_linux_amd64
RUN mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

RUN wget https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${terragrunt_atlantis_config_version}/terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64.tar.gz
RUN tar xf terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64.tar.gz
RUN mv terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64/terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64  /usr/local/bin/terragrunt-atlantis-config
RUN chmod +x /usr/local/bin/terragrunt-atlantis-config

# Infracost related
RUN apk --update --no-cache add ca-certificates openssl openssh-client curl git jq nodejs npm

RUN \
  # Install latest infracost version
  curl -s -L https://github.com/infracost/infracost/releases/latest/download/infracost-linux-amd64.tar.gz | tar xz -C /tmp && \
  mv /tmp/infracost-linux-amd64 /usr/bin/infracost && \
  # Fetch the atlantis_diff.sh script that runs infracost
  curl -s -L -o /home/atlantis/infracost_atlantis_diff.sh https://raw.githubusercontent.com/infracost/infracost/master/scripts/ci/atlantis_diff.sh && \
  chmod +x /home/atlantis/infracost_atlantis_diff.sh && \
  ln -s /home/atlantis/infracost_atlantis_diff.sh /infracost_atlantis_diff.sh

# Install the latest compost version
RUN npm install -g @infracost/compost