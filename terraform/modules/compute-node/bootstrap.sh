#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Bootstrap Process..."

apt-get update -y
apt-get upgrade -y
apt-get install -y \
    git \
    software-properties-common \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https \
    python3-pip \
    python3-kubernetes \
    unattended-upgrades \
    wireguard

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64) SOPS_ARCH="amd64" ;;
    arm64) SOPS_ARCH="arm64" ;;
    *)
        echo "Unsupported architecture for sops: $ARCH"
        exit 1
        ;;
esac

SOPS_VERSION="v3.10.2"
curl -fsSL "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.${SOPS_ARCH}" -o /usr/local/bin/sops
chmod +x /usr/local/bin/sops

apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

REPO_URL="https://github.com/FerdinandWohlstein/infrastructure-live.git"
REPO_REF="main"
TMP_REPO_DIR="$(mktemp -d)"

git clone --depth 1 --branch "$REPO_REF" "$REPO_URL" "$TMP_REPO_DIR"
ansible-galaxy collection install -r "$TMP_REPO_DIR/ansible/requirements.yml"
rm -rf "$TMP_REPO_DIR"

echo "Pulling Ansible configuration..."
ansible-pull -U "$REPO_URL" \
             -C "$REPO_REF" \
             -i "localhost," \
             -l "all" \
             -e "ansible_connection=local" \
             ansible/site.yml

echo "Bootstrap Complete!"
