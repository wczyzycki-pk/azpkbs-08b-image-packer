#!/bin/bash

# Get the latest image version from Azure Shared Image Gallery
LATEST_VERSION=$(az sig image-version list \
  --gallery-name shared_image_gallery \
  --gallery-image-definition azpkbc-lab08b-base-image \
  --resource-group azpkbc-rg-advanced-labs \
  --subscription $ARM_SUBSCRIPTION_ID \
  --query "sort_by(@, &name)[-1].name" \
  --output tsv 2>/dev/null || echo "0.0.0")

# Increment the patch version
IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_VERSION"
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"

echo "Latest version: $LATEST_VERSION"
echo "New version: $NEW_VERSION"

# Run Packer with the new version
cd packer
packer init .
packer build -var "image_version=$NEW_VERSION" .
