#!/bin/bash

# Define variables
PROJECT_ID="kxn-dev-442623"
SERVICE_ACCOUNT_NAME="vpv-peering-sa"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# List of roles to assign
ROLES=("roles/compute.admin" 
       "roles/iam.serviceAccountUser" 
       "roles/storage.admin" 
       "roles/editor")

# Ensure the service account exists before proceeding
echo "Checking if service account exists..."
if ! gcloud iam service-accounts describe $SERVICE_ACCOUNT_EMAIL --project=$PROJECT_ID &>/dev/null; then
    echo "Service account does not exist. Creating service account..."
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
        --display-name "GitHub Actions Service Account" \
        --project=$PROJECT_ID
else
    echo "Service account already exists."
fi

# Assign roles to the service account
echo "Assigning roles to the service account..."
for ROLE in "${ROLES[@]}"; do
    echo "Assigning role $ROLE to $SERVICE_ACCOUNT_EMAIL..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
        --role="$ROLE" \
        --quiet
done

echo "Roles assigned successfully to $SERVICE_ACCOUNT_EMAIL."
