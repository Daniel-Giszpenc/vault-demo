# vault-demo
---

# Ground Covered
---
pt1-deploy
- Certificate and TLS Basics: Create a self signed cert for Vault and use for bridging other nodes to Vault.
- Deployment Basics: Vault with Docker Compose and raft storage.
- Unseal Vault: Shamir's secret sharing.

pt2-configure
- Terraform Vault Provider: Configure resources in Vault with terraform.
- Vault Cli: Manage secrets, manage leases, enable an audit device.
- App Secrets: Show incomplete cli app approach to secrets for how devex can work out.

pt3-use
- Ephemeral Terraform Resources: Injecting vars to terraform modules from Vault
- Cloud Requirements for Vault: Create IAM material for managing id in the future with Vault.
- Dynamic Cloud Credentials: Dynamic terraform vault+aws providers to assume an AWS role.
