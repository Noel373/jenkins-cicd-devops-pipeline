#!/bin/bash
set -euo pipefail

AM_VERSION="0.27.0"
AM_USER="alertmanager"

echo "[INFO] Installing Alertmanager..."

# Create user
id -u ${AM_USER} &>/dev/null || sudo useradd -r -s /usr/sbin/nologin ${AM_USER}

# Create directories
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager
sudo chown -R ${AM_USER}:${AM_USER} /etc/alertmanager /var/lib/alertmanager

# Download
cd /tmp
curl -LO https://github.com/prometheus/alertmanager/releases/download/v${AM_VERSION}/alertmanager-${AM_VERSION}.linux-amd64.tar.gz
tar xzf alertmanager-${AM_VERSION}.linux-amd64.tar.gz

# Install binary
sudo mv alertmanager-${AM_VERSION}.linux-amd64/alertmanager /usr/local/bin/
sudo chmod 755 /usr/local/bin/alertmanager

# Copy config
sudo cp alertmanager/alertmanager.yml /etc/alertmanager/
sudo chown ${AM_USER}:${AM_USER} /etc/alertmanager/alertmanager.yml

# Service file
sudo tee /etc/systemd/system/alertmanager.service >/dev/null <<EOF
[Unit]
Description=Alertmanager
After=network.target

[Service]
User=${AM_USER}
Group=${AM_USER}
Type=simple
EnvironmentFile=/etc/alertmanager/alertmanager.env
ExecStart=/usr/local/bin/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable --now alertmanager

echo "[OK] Alertmanager installed and running"
