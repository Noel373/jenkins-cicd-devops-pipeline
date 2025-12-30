#!/bin/bash
set -e

NE_VERSION="1.8.1"
NE_USER="node_exporter"

echo "[INFO] Installing Node Exporter..."

# Create user if not exists
id -u ${NE_USER} &>/dev/null || sudo useradd -r -s /usr/sbin/nologin ${NE_USER}

# Download & extract
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v${NE_VERSION}/node_exporter-${NE_VERSION}.linux-amd64.tar.gz
tar xzf node_exporter-${NE_VERSION}.linux-amd64.tar.gz

# Install binary
sudo mv node_exporter-${NE_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo chmod 755 /usr/local/bin/node_exporter
sudo chown root:root /usr/local/bin/node_exporter

# Install service
sudo tee /etc/systemd/system/node_exporter.service >/dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
User=${NE_USER}
Group=${NE_USER}
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter --no-pager

echo "[OK] Node Exporter installed and running"