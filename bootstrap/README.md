# Bootstrap

One-time manual setup 

## Prerequisites

Install local tools:
```bash
brew install gh age sops jq yq awscli
```

## Steps

1. Generate age key for SOPS
```bash
mkdir -p "$HOME/Library/Application Support/sops/age"
age-keygen -o "$HOME/Library/Application Support/sops/age/keys.txt"
chmod 600 "$HOME/Library/Application Support/sops/age/keys.txt"
```

2. Obtain Timeweb credentials
2.1. **API token**
2.2. **S3 keys**

3. Create encrypted secrets file
```bash
cat > secrets.sops.yaml <<YAML
twc_token: <your-api-token>
s3_access_key_id: <your-s3-key>
s3_secret_access_key: <your-s3-secret>
YAML

sops -e -i secrets.sops.yaml
```

4. Configure local AWS profile
```bash
./bootstrap/scripts/setup-aws-profile.sh
```

5. Create the state bucket
Create the bucket manually via the Timeweb panel:
- Name: `tofu-playground-state`
- Type: **Private**
- Size: 1 GB
- Region: Saint-Petersburg (ru-1)

Then run:

```bash
./bootstrap/scripts/create-state-bucket.sh
```