#!/bin/bash
# Install and start Nexus as a service 
# This script works on RHEL 7 & 8 OS 
# Your server must have at least 4GB of RAM
# Become the root / admin user via: sudo su -

# 1. Create nexus user to manage the nexus
# As a good security practice, Nexus is not advised to run nexus service as a root user,
# so create a new user called nexus and grant sudo access to manage nexus services as follows.

sudo useradd nexus

# 2. Give sudo access to nexus user
sudo bash -c 'echo "nexus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nexus'

# 3. Switch to root or stay as root to proceed with the installation
cd /opt

# 4. Install prerequisites: JAVA, git, unzip
sudo yum install wget git nano unzip -y
sudo yum install java-11-openjdk-devel -y

# 5. Download nexus software and extract it (unzip)
sudo wget https://download.sonatype.com/nexus/3/nexus-3.15.2-01-unix.tar.gz

sudo tar -zxvf nexus-3.15.2-01-unix.tar.gz
sudo mv nexus-3.15.2-01 nexus
sudo mkdir -p /opt/sonatype-work

# 6. Change the owner and group permissions to /opt/nexus and /opt/sonatype-work directories
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work

# 7. Set nexus user in nexus.rc
sudo bash -c 'echo "run_as_user=\"nexus\"" > /opt/nexus/bin/nexus.rc'

# 8. Configure Nexus to run as a service
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

# 9. Enable and start the nexus service
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus

echo "End of Nexus installation"

# =====================
# Access Nexus on the browser
# http://<your-ec2-public-ip>:8081
# Default Username: admin
# Password: See /opt/sonatype-work/nexus3/admin.password

# <<Troubleshooting
# ---------------------
# Nexus service is not starting?
# a) Make sure to change the ownership and group to /opt/nexus and /opt/sonatype-work (user: nexus)
# b) Make sure you are trying to start nexus service as nexus user
# c) Check if Java is installed using: java -version
# d) Check logs at: /opt/sonatype-work/nexus3/log/nexus.log

# Unable to access Nexus URL?
# a) Ensure port 8081 is open in your EC2 security group
