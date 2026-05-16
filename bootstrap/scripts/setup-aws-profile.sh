#!/usr/bin/env bash

set -euo pipefail

PROFILE="${AWS_PROFILE_NAME:-timeweb}"
SECRETS_FILE="${SECRETS_FILE:-secrets.sops.yaml}"
REGION="${REGION:-ru-1}"

if [[ ! -f "$SECRETS_FILE" ]]; then
    echo "Error: $SECRETS_FILE not found." >&2
    exit 1
fi

echo "==> Decrypring credentials from $SECRETS_FILE..."
S3_KEY_ID=$(sops -d "$SECRETS_FILE" | yq '.s3_access_key_id')
S3_KEY_SECRET=$(sops -d "$SECRETS_FILE" | yq '.s3_secret_access_key')

if [[ -z "$S3_KEY_ID" || "$S3_KEY_ID" == "null" ]]; then
    echo "Error: s3_access_key_id not found in secrets file" >&2
    exit 1
fi

echo "==> Writing profile '$PROFILE' to ~/.aws/credentials..."
aws configure set aws_access_key_id     "$S3_KEY_ID"        --profile "$PROFILE"
aws configure set aws_secret_access_key "$S3_KEY_SECRET"    --profile "$PROFILE"
aws configure set region                "$REGION"           --profile "$PROFILE"

uset S3_KEY_ID S3_KEY_SECRET

echo "====> Done."