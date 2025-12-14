#!/bin/bash
set -euo pipefail

# =========================
# Variables
# =========================
ENABLE_ZSH="${ENABLE_ZSH:-false}"
MINIKUBE_VERSION="v1.34.0"
KUBERNETES_VERSION="v1.31.1"
CRICTL_VERSION="v1.31.0"
CNI_VERSION="v1.5.1"
GO_VERSION="1.21.1"

# =========================
# Fix CentOS 7 repos
# =========================
sudo sed -i \
  -e 's|mirror.centos.org|vault.centos.org|g' \
  -e 's|^#.*baseurl=http|baseurl=http|g' \
  -e 's|^mirrorlist=http|#mirrorlist=http|g' \
  /etc/yum.repos.d/*.repo

sudo yum clean all
sudo yum -y update

# =========================
# Base packages
# =========================
sudo yum install -y \
  yum-utils \
  git wget curl \
  conntrack socat \
  bash-completion

# =========================
# Disable SELinux
# =========================
sudo setenforce 0 || true
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

# =========================
# Docker
# =========================
sudo yum remove -y docker* || true
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable --now docker
sudo usermod -aG docker vagrant

# Needed for Kubernetes
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# =========================
# Minikube
# =========================
curl -LO "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64"
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# =========================
# kubectl
# =========================
curl -LO "https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl
rm -f kubectl

# =========================
# crictl
# =========================
curl -LO "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz"
tar -xzf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
sudo mv crictl /usr/local/bin/
rm -f crictl-${CRICTL_VERSION}-linux-amd64.tar.gz

# =========================
# CNI plugins
# =========================
curl -LO "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz"
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-${CNI_VERSION}.tgz
rm -f cni-plugins-linux-amd64-${CNI_VERSION}.tgz

# =========================
# Start Minikube (Docker driver)
# =========================
su - vagrant -c "
minikube start \
