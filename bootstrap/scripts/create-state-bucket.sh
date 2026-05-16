#!/usr/bin/env bash

set -eou pipefail

BUCKET_NAME="${BUCKET_NAME:-tofu-playground-state}"
ENDPOINT_URL="${ENDPOINT_IRL:-https://s3.twcstorage.ru}"
AWS_PROFILE="${AWS_PROFILE:-timeweb}"

echo "==> Checking if bucket '$BUCKET_NAME' exists..."
if aws --profile "$AWS_PROFILE" \
        --endpoint-url "$ENDPOINT_URL" \
        s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "      Bucket already exists, skipping creation"
else
    echo "==> Creating bucket '$BUCKET_NAME'..."
    aws --profile "$AWS_PROFILE" \
        --endpoint-url "$ENDPOINT_URL" \
        s3api create-bucket --bucket "$BUCKET_NAME" || {
            echo "      Automatic creation failed. Create the bucket manually"
            exit 1
        }
fi

echo "==> Enabling versioning..."
aws --profile "$AWS_PROFILE" \
    --endpoint-url "$ENDPOINT_URL" \
    s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

echo "==> Verifying versioning is enabled..."
aws --profile "$AWS_PROFILE" \
    --endpoint-url "$ENDPOINT_URL" \
    s3api get-bucket-versioning \
    --bucket "$BUCKET_NAME"

echo ""
echo "====> Done"