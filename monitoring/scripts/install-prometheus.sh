#!/usr/bin/env bash
set -e

PROMETHEUS_VERSION="2.51.0"
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

sudo useradd --no-create-home --shell /bin/false prometheus || true

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/

sudo mkdir -p /etc/prometheus /var/lib/prometheus

sudo cp "${BASE_DIR}/prometheus/prometheus.yml" /etc/prometheus/prometheus.yml
sudo cp "${BASE_DIR}/prometheus/alert.rules.yml" /etc/prometheus/alert.rules.yml
sudo cp "${BASE_DIR}/services/prometheus.service" /etc/systemd/system/prometheus.service

sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo chmod 755 /usr/local/bin/prometheus /usr/local/bin/promtool

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

