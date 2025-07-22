#!/bin/bash
# run as user-data for worker nodes in a Kubernetes cluster
set -euxo pipefail

# Log output to /var/log/user-data.log
exec > /var/log/user-data.log 2>&1

# Wait for cloud-init to fully finish networking
while ! curl -s --max-time 2 https://google.com >/dev/null; do
  echo " Waiting for internet connection..."
  sleep 5
done

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load required kernel modules and sysctl params
modprobe br_netfilter
echo 'br_netfilter' > /etc/modules-load.d/br_netfilter.conf

cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Install containerd
apt-get update -y
apt-get install -y containerd

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install kubeadm, kubelet, kubectl
apt-get install -y apt-transport-https ca-certificates curl gnupg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg
echo "deb https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet

# Join the cluster
kubeadm join 172.31.0.91:6443 --token e0fv9j.34jjl9ywe1iv4c11 \
  --discovery-token-ca-cert-hash sha256:711724e98514612c7f1c97ff1294bbe85cec3f895cb063e7c1e7ed4477792c4d
