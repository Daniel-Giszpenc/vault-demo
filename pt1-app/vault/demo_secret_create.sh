#!/usr/bin/env bash

# remember to login!

vault kv put dev-secrets/app/good_message \
    msg="top of the morning!"

vault kv put infra-secrets/tailscale_aws_auth_key \
    msg="<redacted>"

vault kv put infra-secrets/tailscale_aws_auth_key key="<redacted-v2>"

vault token create -ttl=1h -use-limit=2 -policy="developer-access"
export USE_LIMIT_TOKEN=<your-token>
VAULT_TOKEN=$USE_LIMIT_TOKEN vault token lookup

vault list sys/leases/lookup
vault list sys/leases/lookup/aws/creds/vault-terraform
vault lease lookup aws/creds/vault-terraform/short-id
vault lease revoke aws/creds/vault-terraform/short-id