#install ansible on ubuntu
#!/bin/bash

# Update and install prerequisites
sudo apt update
sudo apt install -y software-properties-common

# Add Ansible PPA and install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Create a dedicated 'ansible' user (optional but recommended)
sudo adduser --disabled-password --gecos "" ansible

# Grant passwordless sudo to the ansible user
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible

# Change ownership of Ansible config directory to the ansible user
sudo chown -R ansible:ansible /etc/ansible