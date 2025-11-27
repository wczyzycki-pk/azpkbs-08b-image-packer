#!/bin/bash
# SSH key setup script template

set -e

# Setup SSH key for root user
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
echo '${ssh_public_key}' | sudo tee -a /root/.ssh/authorized_keys > /dev/null
sudo chmod 600 /root/.ssh/authorized_keys
echo 'SSH key added for root user'
