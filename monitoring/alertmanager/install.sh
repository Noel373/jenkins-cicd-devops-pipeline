#!/bin/bash
set -e

VERSION="0.27.0"
USER="alertmanager"

echo "==> Copying configuration files"
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager
sudo cp ./alertmanager.yml /etc/alertmanager/alertmanager.yml
sudo cp ./alertmanager.service /etc/systemd/system/alertmanager.service

echo "==> Creating user"
sudo useradd -r -s /bin/false $USER || true

echo "==> Installing Alertmanager"
cd /tmp
wget https://github.com/prometheus/alertmanager/releases/download/v${VERSION}/alertmanager-${VERSION}.linux-amd64.tar.gz
tar xzf alertmanager-${VERSION}.linux-amd64.tar.gz

sudo mv alertmanager-${VERSION}.linux-amd64/alertmanager /usr/local/bin/
sudo mv alertmanager-${VERSION}.linux-amd64/amtool /usr/local/bin/

sudo chown -R $USER:$USER /etc/alertmanager /var/lib/alertmanager
sudo chmod 755 /usr/local/bin/alertmanager /usr/local/bin/amtool

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

echo "==> Alertmanager installed successfully"

