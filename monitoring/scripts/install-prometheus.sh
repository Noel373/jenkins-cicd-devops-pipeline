#!/bin/bash
set -euo pipefail

PROM_VERSION="2.52.0"
PROM_USER="prometheus"

echo "[INFO] Installing Prometheus..."

# Create user
id -u ${PROM_USER} &>/dev/null || sudo useradd -r -s /usr/sbin/nologin ${PROM_USER}

# Create directories first
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown -R ${PROM_USER}:${PROM_USER} /etc/prometheus /var/lib/prometheus

# Download
cd /tmp
curl -LO https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Install binaries
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo chmod 755 /usr/local/bin/prometheus /usr/local/bin/promtool

# Copy configs (assumes repo layout)
sudo cp prometheus/prometheus.yml /etc/prometheus/
sudo cp prometheus/alert.rules.yml /etc/prometheus/
sudo chown ${PROM_USER}:${PROM_USER} /etc/prometheus/*.yml

# Install service
sudo tee /etc/systemd/system/prometheus.service >/dev/null <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=${PROM_USER}
Group=${PROM_USER}
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.enable-lifecycle

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus

echo "[OK] Prometheus installed and running"
