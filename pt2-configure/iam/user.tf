variable "vault_user_name" {
    description = "IAM user name for Vault's AWS secrets engine root config"
    type        = string
    default     = "vault-aws-root"
}

variable "managed_user_prefix" {
    description = "Prefix Vault will use when dynamically creating IAM users (iam_user credential_type)"
    type        = string
    default     = "vault-"
}

resource "aws_iam_user" "vault" {
    name = var.vault_user_name
    path = "/"
}

resource "aws_iam_access_key" "vault" {
    user = aws_iam_user.vault.name
}

# Permissions Vault needs at aws/config/root to support the iam_user,
# assumed_role, and federation_token credential types.
# Narrow the Statements/Resources further if you only use one credential type.
data "aws_iam_policy_document" "vault_aws_secrets_engine" {
    statement {
        sid    = "ManageDynamicIamUsers"
        effect = "Allow"
        actions = [
            "iam:CreateUser",
            "iam:DeleteUser",
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:ListAccessKeys",
            "iam:GetUser",
            "iam:PutUserPolicy",
            "iam:DeleteUserPolicy",
            "iam:ListUserPolicies",
            "iam:AttachUserPolicy",
            "iam:DetachUserPolicy",
            "iam:ListAttachedUserPolicies",
            "iam:AddUserToGroup",
            "iam:RemoveUserFromGroup",
            "iam:ListGroupsForUser",
        ]
        resources = [
            "arn:aws:iam::*:user/${var.managed_user_prefix}*",
        ]
    }

    statement {
        sid       = "AssumedRoleCredentialType"
        effect    = "Allow"
        actions   = ["sts:AssumeRole"]
        resources = ["*"]
    }

    statement {
        sid       = "FederationTokenCredentialType"
        effect    = "Allow"
        actions   = ["sts:GetFederationToken"]
        resources = ["*"]
    }
}

resource "aws_iam_user_policy" "vault_aws_secrets_engine" {
    name   = "vault-aws-secrets-engine"
    user   = aws_iam_user.vault.name
    policy = data.aws_iam_policy_document.vault_aws_secrets_engine.json
}

output "access_key_id" {
    value = aws_iam_access_key.vault.id
}

output "secret_access_key" {
    value     = aws_iam_access_key.vault.secret
    sensitive = true
}