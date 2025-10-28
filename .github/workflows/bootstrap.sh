#!/bin/bash
set -e

# Usage: ./create_tf_backend.sh dev|test|prod

# Input variables
ENV=$1  # Environment name
if [ -z "$ENV" ]; then
  echo "Usage: $0 <env>"
  echo "Example: $0 dev"
  exit 1
fi

RESOURCE_GROUP="prenv-management-RG"
LOCATION="westeurope"
STORAGE_ACCOUNT="tfstateprenvfozzen"
CONTAINER_NAME="tfstate-${ENV,,}"

echo "Setting up Terraform backend for environment: ${ENV}"

# Check if storage account exists
if ! az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" &> /dev/null; then
  echo "Creating storage account..."
  az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2
else
  echo "Storage account '$STORAGE_ACCOUNT' already exists."
fi

# Get account key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" -o tsv)

# Create container (idempotent)
echo "Creating blob container for environment '$ENV'..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY" \
  --output none

echo "Storage container '$CONTAINER_NAME' ready in storage account '$STORAGE_ACCOUNT'."
