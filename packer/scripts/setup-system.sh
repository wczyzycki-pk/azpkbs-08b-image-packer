#!/bin/bash
# System setup script for Debian image
# Installs basic tools and Azure CLI

set -e

# Fix apt issues and update system
echo "Fixing apt system..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean

# Add Debian backports for additional packages (e.g., btop)
echo "Adding Debian backports repository..."
echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/backports.list

echo "Updating package lists..."
sudo apt-get update
echo "Upgrading system packages..."
sudo apt-get upgrade -y

# Install basic text tools
sudo apt-get install -y \
  curl wget \
  openssh-client openssl \
  ca-certificates \
  htop \
  dnsutils \
  netcat-openbsd \
  python3 python3-pip \
  git \
  vim \
  net-tools \
  jq \
  nginx

# Install btop from backports
sudo apt-get install -y -t bookworm-backports btop

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Setup SSH key for packer user
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$SSH_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Wyłącz root login przez SSH
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH
sudo systemctl restart ssh

# Logowanie
sudo sh -c 'echo "Minimal jump-host initialized at $(date)" >> /var/log/jump-host.log'
