#!/usr/bin/env bash

# remember to login!

vault kv put dev-secrets/app/good_message \
    msg="top of the morning!"

vault kv put infra-secrets/tailscale_aws_auth_key \
    msg="<redacted>"

vault kv put infra-secrets/tailscale_aws_auth_key key="<redacted-v2>"