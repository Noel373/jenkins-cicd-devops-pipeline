#!/bin/bash
set -e

VERSION="2.49.0"
USER="prometheus"

echo "==> Copying configuration files"
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo cp ./prometheus.yml /etc/prometheus/prometheus.yml
sudo cp ./alert.rules.yml /etc/prometheus/alert.rules.yml
sudo cp ./prometheus.service /etc/systemd/system/prometheus.service

echo "==> Creating user"
sudo useradd --no-create-home --shell /bin/false $USER || true

echo "==> Installing Prometheus"
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
tar xzf prometheus-${VERSION}.linux-amd64.tar.gz

sudo mv prometheus-${VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${VERSION}.linux-amd64/promtool /usr/local/bin/

sudo chown -R $USER:$USER /etc/prometheus /var/lib/prometheus
sudo chmod 755 /usr/local/bin/prometheus /usr/local/bin/promtool

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo "==> Prometheus installed successfully"