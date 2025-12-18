#!/bin/bash
# This script sets up a Kubernetes worker node on an Ubuntu system
# Run this script with: sudo bash worker-node.sh

set -e

echo "[1] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "[2] Loading required kernel modules..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

echo "[3] Applying sysctl params..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

echo "[4] Installing containerd..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

echo "[5] Configuring containerd with systemd cgroup..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "[6] Installing Kubernetes components (kubeadm, kubelet)..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
  gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm
sudo apt-mark hold kubelet kubeadm

echo "[7] Joining the Kubernetes cluster..."
sudo kubeadm join 172.31.24.212:6443 --token 59d3x6.yfmgfn3bf2r53s0y \
<<<<<<< HEAD
        --discovery-token-ca-cert-hash sha256:7010de295bf9a00b605523686dbe6605859a795c868f223072443551c355ebc
=======
        --discovery-token-ca-cert-hash sha256:7010de295bf9a00b605523686dbe6605859a795c868f223072443551c355ebc
>>>>>>> 800805ce98e8e050d34f0dfe8f3a7e825afab791
