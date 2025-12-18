#!/bin/bash
# User data script to configure Kubernetes worker node

exec > /var/log/user-data.log 2>&1
set -euxo pipefail

echo "[1] Disabling swap..."
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

echo "[2] Loading kernel modules..."
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "[3] Applying sysctl settings..."
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "[4] Installing containerd..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor | tee /etc/apt/keyrings/docker.gpg > /dev/null

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y containerd.io

echo "[5] Configuring containerd with systemd cgroup..."
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml > /dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

echo "[6] Installing Kubernetes tools..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
  gpg --dearmor | tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm
apt-mark hold kubelet kubeadm
systemctl enable kubelet
systemctl start kubelet

systemctl enable kubelet
systemctl start kubelet

echo "[7] Joining the Kubernetes cluster..."
# NOTE: Replace below with your actual join command
kubeadm join 172.31.24.212:6443 --token 59d3x6.yfmgfn3bf2r53s0y \
  --discovery-token-ca-cert-hash sha256:7010de295bf9a00b605523686dbe6605859a795c868f223072443551c355ebc0
