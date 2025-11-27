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
echo "Updating package lists..."
sudo apt-get update
echo "Upgrading system packages..."
sudo apt-get upgrade -y

# Install basic text tools
sudo apt-get install -y \
  curl \
  wget \
  git \
  vim \
  htop \
  net-tools \
  jq \
  bash \
  openssh-client \
  ca-certificates \
  python3 \
  python3-pip \
  nginx

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
