#!/usr/bin/env bash
set -e

# Variables

ALERTMANAGER_VERSION="0.27.0"

REPO_BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_SRC="${REPO_BASE_DIR}/alertmanager/alertmanager.yml"
SERVICE_SRC="${REPO_BASE_DIR}/services/alertmanager.service"

CONFIG_DST="/etc/alertmanager/alertmanager.yml"
SERVICE_DST="/etc/systemd/system/alertmanager.service"

# Pre-flight checks

if [ ! -f "$CONFIG_SRC" ]; then
  echo " Missing alertmanager.yml at $CONFIG_SRC"
  exit 1
fi

if [ ! -f "$SERVICE_SRC" ]; then
  echo " Missing alertmanager.service at $SERVICE_SRC"
  exit 1
fi

echo " Installing Alertmanager ${ALERTMANAGER_VERSION}"

# Download & install binaries

cd /tmp

wget -q https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar -xzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz

sudo useradd -r -s /bin/false alertmanager || true
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager

sudo mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/alertmanager /usr/local/bin/
sudo mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool /usr/local/bin/

sudo chmod 755 /usr/local/bin/alertmanager /usr/local/bin/amtool

rm -rf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64*

# Copy configuration & service

sudo cp "$CONFIG_SRC" "$CONFIG_DST"
sudo cp "$SERVICE_SRC" "$SERVICE_DST"

# Permissions

sudo chown -R alertmanager:alertmanager /etc/alertmanager /var/lib/alertmanager
sudo chmod 644 /etc/alertmanager/alertmanager.yml

# systemd setup
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl restart alertmanager

# Status
echo " Alertmanager installation complete"
systemctl --no-pager status alertmanager

