#!/bin/bash
set -euo pipefail

echo "[INFO] Installing Grafana safely..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget

# Add Grafana GPG key
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg

# Add Grafana repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  | sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null

# Install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Enable and start Grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "[OK] Grafana installed and running"
