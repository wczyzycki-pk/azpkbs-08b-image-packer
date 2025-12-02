#!/bin/bash

set -e

echo "Configuring Polish locale..."
sudo apt-get install -y locales >/dev/null 2>&1
# Uncomment Polish locale
sudo sed -i 's/# pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen
# Generate locale
sudo locale-gen pl_PL.UTF-8 >/dev/null 2>&1
# Determine correct locale name
if locale -a 2>/dev/null | grep -q "pl_PL.UTF-8"; then
    LOCALE_NAME="pl_PL.UTF-8"
elif locale -a 2>/dev/null | grep -q "pl_PL.utf8"; then
    LOCALE_NAME="pl_PL.utf8"
else
    echo "Warning: Polish locale not available"
    LOCALE_NAME="C.UTF-8"
fi
# Set system locale (suppress all output to prevent Packer failure)
#sudo update-locale LANG=$LOCALE_NAME LC_ALL=$LOCALE_NAME LANGUAGE=pl_PL:pl:en >/dev/null 2>&1 || true
# Set timezone
sudo timedatectl set-timezone Europe/Warsaw >/dev/null 2>&1 || true
echo "Locale configuration completed (using: $LOCALE_NAME)"
