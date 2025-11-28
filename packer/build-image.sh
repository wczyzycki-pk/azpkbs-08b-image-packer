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
packer init .
echo "packer build -force -var \"image_version=$NEW_VERSION\" ."
packer build -force -var "image_version=$NEW_VERSION" .

# Calculate end of life date (6 months from now)
END_OF_LIFE_MONTHS=6
END_DATE=$(date -v+${END_OF_LIFE_MONTHS}m +%Y-%m-%dT%H:%M:%SZ)

# Note: Setting end-of-life date and recommended specs requires Azure CLI with support for these parameters in update command.
# For now, these properties can be set manually via Azure portal or CLI after build.
echo "Build completed. Image version: $NEW_VERSION"
