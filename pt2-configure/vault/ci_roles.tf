resource "vault_aws_secret_backend" "aws_backend" {
    path        = "aws"
    description = "AWS secrets engine for dynamic IAM credentials"
    access_key  = data.sops_file.sops-secret.data["aws_access_key"]
    secret_key  = data.sops_file.sops-secret.data["aws_secret_key"]
    region      = "us-east-1"
    default_lease_ttl_seconds = 900
    max_lease_ttl_seconds = 3600
}

resource "vault_aws_secret_backend_role" "vault-terraform" {
    depends_on      = [vault_aws_secret_backend.aws_backend]
    backend         = "aws" # Path where AWS secrets engine is mounted
    name            = "vault-terraform"
    role_arns       = ["arn:aws:iam::767398065040:role/vault-terraform-20260715224817494900000001"]
    credential_type = "assumed_role"
    default_sts_ttl = 900   # 15 minutes in seconds
    max_sts_ttl     = 3600  # 1 hour in seconds
}

resource "vault_policy" "github_ci_aws" {
    name = "github-oidc-policy"
    policy = <<EOT
    # Allow reading AWS credentials from the AWS secrets engine
    path "aws/creds/vault-terraform" {
        capabilities = ["read"]
    }
    EOT
}

resource "vault_jwt_auth_backend" "github_oidc" {
    description        = "Accept OIDC authentication from GitHub Actions"
    path               = "github-actions"
    type               = "jwt"
    oidc_discovery_url = "https://token.actions.githubusercontent.com"
    bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "github_actions" {
    backend        = vault_jwt_auth_backend.github_oidc.path
    role_name      = "github-actions-role"
    role_type      = "jwt"
    token_policies = [vault_policy.github_ci_aws.name]

    # The audience must match what GitHub sends in the OIDC token
    bound_audiences = ["https://github.com/Daniel-Giszpenc"]

    # The subject claim binds to your repository and conditions.
    # This example binds to the main branch of a specific repo.
    bound_subject = "repo:Daniel-Giszpenc/vault-demo:ref:refs/heads/main"

    # The claim that uniquely identifies the user for Vault's identity system
    user_claim = "job_workflow_ref"
}