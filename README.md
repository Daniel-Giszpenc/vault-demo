# vault-demo
---

### pt1-deploy
- Certificate and TLS Basics: Create a self signed cert for Vault and use for bridging other nodes to Vault.
- Deployment Basics: Vault with Docker Compose and raft storage.
- Unseal Vault: Shamir's secret sharing.

### pt2-configure
- Cloud Requirements for Vault: Create IAM material for managing id in the future with Vault.
- Terraform Vault Provider: Configure resources in Vault with terraform.
- Vault Cli: Manage static secrets.
- App Secrets: Show incomplete cli app approach to secrets to setup a devex discussion.

### pt3-use
- Ephemeral Terraform Resources: Passing vars to terraform modules from Vault. (no state trace)
- Vault Cli: Manage leases, enable an audit device.
- Dynamic Cloud Credentials: Dynamic terraform vault+aws providers to assume an AWS role.
- Audit: Browse Vault audit output.

## Commands
---

### pt1-deploy

On Proxmox server
```bash
mkdir -p /home/ansible/docker/vault
```

On local client
```bash
cd pt1-deploy
scp compose.yaml ansible@100.80.0.1:/home/ansible/docker/vault
```

On Proxmox server
```bash
cd /home/ansible/docker/vault
mkdir -p data logs certs

openssl req -x509 -newkey rsa:4096 -sha256 -days 365 \
      -nodes -keyout certs/vault.key -out certs/vault.crt \
      -subj '/CN=vault' \
      -addext 'subjectAltName=DNS:vault,IP:127.0.0.1,IP:100.80.0.1'

chown -R 100:100 /home/ansible/docker/vault/

docker compose up -d

docker exec -it vault-server /bin/sh
```

On vault shell
```bash
vault operator init -key-shares=5 -key-threshold=3
vault operator unseal <unseal-key-1>
vault operator unseal <unseal-key-2>
vault operator unseal <unseal-key-3>

vault status
```

### pt2-use

On local client
```bash
# current directory is top level of the git clone of this repository
cd pt2-configure/iam
aws login
terraform apply

cd ../vault
terraform apply
```

Separate shell on local client
```bash
# from root of repository
cd secret-scratchpad
sops secrets.yaml
# copy to clipboad: aws_server_ts_auth_key
```

On vault shell
```bash
# use still open tab if available
# docker exec -it vault-server /bin/sh

vault token lookup

vault kv put dev-secrets/app/good_message \
    msg="top of the morning!"

# paste from clipboard to redacted
vault kv put infra-secrets/tailscale_aws_auth_key \
    msg="<redacted>"

vault kv put infra-secrets/tailscale_aws_auth_key key="<redacted-v2>"
```

On local client in code editor

Browse cli-app for discussion for a minute on
- internals secrets via env vars
- internals secrets via sdk

### pt3-use

On local client
```bash
# from root of repository
cd pt3-use/test-env/
terraform plan -var-file=environments/dev.tfvars --out tfplan.binary
```

On vault shell
```bash
# use still open tab if available
# docker exec -it vault-server /bin/sh

vault list sys/leases/lookup

vault list sys/leases/lookup/aws/creds/vault-terraform
vault lease lookup aws/creds/vault-terraform/<short-id>
vault lease revoke aws/creds/vault-terraform/<short-id>

vault audit enable file file_path=/vault/logs/audit.log
vault audit list
```

On local client (resuming from last location)
```bash
terraform apply
```

On vault shell
```bash
cat vault/logs/audit.log
# copy to clipboard and paste in editor log.json
# sort json in editor
```