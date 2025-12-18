# Ansible AWS Passwordless SSH Setup

This project automates passwordless SSH setup for 100+ AWS EC2 instances using a custom AMI and Ansible dynamic inventory.

## ✅ Phase 1: Create a Custom AMI

1. Launch a test EC2 instance (e.g., `server-test`) with any base Linux AMI.
2. SSH into it and create the `ansible` user:
   ```bash
   sudo adduser ansible
   sudo mkdir -p /home/ansible/.ssh
   sudo cp ~/.ssh/authorized_keys /home/ansible/.ssh/
   sudo chown -R ansible:ansible /home/ansible/.ssh
   sudo chmod 700 /home/ansible/.ssh
   sudo chmod 600 /home/ansible/.ssh/authorized_keys
   ```
3. Add this **cloud-init** script when launching from AMI (EC2 user data):
   ```yaml
   #cloud-config
   runcmd:
     - rm -f /etc/ssh/ssh_host_*
     - ssh-keygen -A
     - systemctl restart sshd
   ```
4. Stop the instance and create an AMI from it (this will be your base image for the 100 instances).

## ✅ Phase 2: Launch 100 EC2 Instances

Use this custom AMI to launch 100 EC2 instances, and add the cloud-init script above as **user-data** to regenerate unique SSH host keys on first boot.

## ✅ Phase 3: Configure Ansible

1. Set up your SSH key:
   - Your Ansible control node should have the private key that corresponds to the public key baked into the AMI (`/home/ansible/.ssh/id_rsa`).

2. Place the files in one folder:
   - `ansible.cfg`
   - `aws_ec2.yml`
   - `passwordless-ssh.yml` (optional for server-test)

3. Test dynamic inventory:
   ```bash
   ansible-inventory -i aws_ec2.yml --graph
   ```

4. Ping all hosts:
   ```bash
   ansible all -m ping
   ```

## ✅ Troubleshooting

- **Permission denied (publickey):** Ensure the private key matches what’s in the AMI.
- **Host key mismatch:** Use `host_key_checking = False` in `ansible.cfg`.
- **Can't connect:** Check EC2 Security Groups.

## 🧩 Optional: First-Time Setup Using Playbook

If your `server-test` isn't ready yet, run `passwordless-ssh.yml` to configure it before creating the AMI.
