#!/bin/bash
# Updated SonarQube Setup Script for RHEL/CentOS 7/8

set -e
#installing required packages 
sudo apt update -y 
sudo apt install wget unzip tar -y

echo "Installing  packages..."
cd /opt
#clean up
sudo rm -f sonarqube-*
sudo rm -f OpenJDK17U-*
sudo wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_x64_linux_hotspot_17.0.11_9.tar.gz
sudo tar -xvzf OpenJDK17U-jdk_x64_linux_hotspot_17.0.11_9.tar.gz
sudo mv jdk-17.0.11+9 /opt/jdk17

# Set JAVA_HOME and PATH
echo "export JAVA_HOME=/opt/jdk17" | sudo tee -a /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a /etc/profile
source /etc/profile

# Test it
java -version

echo "Creating sonar user..."
sudo useradd sonar || true
echo "sonar ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonar

echo "Downloading SonarQube 9.9 LTS..."
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.4.87374.zip
sudo unzip sonarqube-9.9.4.87374.zip
sudo rm -f sonarqube-9.9.4.87374.zip
sudo mv sonarqube-9.9.4.87374 sonarqube

echo "Setting permissions..."
sudo chown -R sonar:sonar /opt/sonarqube/
sudo chmod -R 775 /opt/sonarqube/

echo "Starting SonarQube as 'sonar' user..."
sudo su - sonar -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"

echo "SonarQube started. Access it at: http://<your-server-ip>:9000"
