#!/bin/bash

# Update package list and install Ansible
apt update -y
apt install -y ansible

# Create .ssh directory if it doesn't exist (for ubuntu user)
mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

# Create SSH private key file for the ubuntu user
cat <<EOF > /home/ubuntu/.ssh/id_rsa
${private_key_content}
EOF

# Set correct permissions and ownership for private key
chmod 400 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa

# Add managed nodes to known_hosts to avoid SSH authenticity prompts
sudo -u ubuntu ssh-keyscan -H ${managed_ip_1} >> /home/ubuntu/.ssh/known_hosts
sudo -u ubuntu ssh-keyscan -H ${managed_ip_2} >> /home/ubuntu/.ssh/known_hosts
chmod 644 /home/ubuntu/.ssh/known_hosts
chown ubuntu:ubuntu /home/ubuntu/.ssh/known_hosts

# Create Ansible inventory file listing the managed nodes
cat <<EOF > /home/ubuntu/inventory.ini
[managed_nodes]
${managed_ip_1}
${managed_ip_2}
EOF
chown ubuntu:ubuntu /home/ubuntu/inventory.ini

# Create Ansible configuration file with basic settings
cat <<EOF > /home/ubuntu/ansible.cfg
[defaults]
inventory = /home/ubuntu/inventory.ini
host_key_checking = False
EOF
chown ubuntu:ubuntu /home/ubuntu/ansible.cfg
