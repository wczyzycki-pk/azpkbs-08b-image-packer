#!/bin/bash
# Cleanup script for image preparation
# Reduces disk usage before capture

# Note: Not using set -e because some cleanup operations may fail due to permissions
# but we want to continue with other cleanup tasks

# Cleanup before capture
export DEBIAN_FRONTEND=noninteractive

# Clean apt caches and lists
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /var/cache/apt/archives/*
sudo rm -rf /var/cache/*

# Autoremove unused packages
sudo apt-get autoremove -y

# Remove temporary files (skip systemd private dirs)
find /tmp -mindepth 1 -maxdepth 1 -not -name 'systemd-private-*' -exec sudo rm -rf {} + 2>/dev/null || true
sudo rm -rf /var/tmp/*

# Truncate log files (skip permission errors)
if [ -d /var/log ]; then
  find /var/log -type f -name "*.[0-9]" -delete 2>/dev/null || true
  find /var/log -type f -exec sh -c 'truncate -s 0 "$1" 2>/dev/null || true' _ {} \;
fi

# Vacuum systemd journal
if command -v journalctl >/dev/null 2>&1; then
  sudo journalctl --vacuum-size=50M 2>/dev/null || true
fi

# Clear apt cache in user homes
find / -type d -name ".cache" -prune -o -name "apt" -path "*/.cache/*" -exec rm -rf {} + 2>/dev/null || true

# Log completion
echo "VM initialization completed at $(date)" | sudo tee -a /var/log/packer-custom.log > /dev/null
sudo chmod 644 /var/log/packer-custom.log 2>/dev/null || true
