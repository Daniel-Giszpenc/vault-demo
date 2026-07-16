module "iam_role-vault-terraform" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role"
    version = "6.4.0"

    name = "vault-terraform"

    trust_policy_permissions = {
        TrustUsersToAssume = {
            actions = [
                "sts:AssumeRole",
                "sts:TagSession",
            ]
            // root implies trust for all users in its account
            // auth responsability falls on AssumeRole permissions
            principals = [{
                type = "AWS"
                identifiers = [
                    "arn:aws:iam::767398065040:root",
                ]
            }]
            // if external accounts were also a factor
            # condition = [{
            #     test     = "StringEquals"
            #     variable = "sts:ExternalId"
            #     values   = ["some-secret-id"]
            # }]
        }
    }

    policies = {
        vault-terraform = aws_iam_policy.vault-terraform.arn
    }

    tags = {
        Environment = "pt1"
        Project     = "vault-demo"
    }
}

// NOTE:
// strict checking here comes from OPA validation in central CI
// that is where strict tagging requirements are enforced because
// AWS has poor tag policy management support and OPA is better at it
data "aws_iam_policy_document" "vault-terraform" {
    statement {
        sid     = "AllowActions"
        effect  = "Allow"
        actions = [
            "ec2:*",
            "elasticloadbalancing:*",
            "dynamodb:*"
        ]
        resources = ["*"]
    }

    // need StateBackendAccess here declared for user permissions
    // because assume_role is not working with backend config
    statement {
        sid = "StateBackendAccess"
        // copied IAMFullAccess managed policy
        actions = [
                "s3:CreateBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:GetBucketLocation"
        ]
        resources = [
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1",
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1/*"
        ]
    }
}

resource "aws_iam_policy" "vault-terraform" {
    name   = "vault-terraform"
    description = "Policy for managing all Project:Personal-Website resources"
    path   = "/"
    policy = data.aws_iam_policy_document.vault-terraform.json

    tags = {
        Environment = "pt1"
        Project     = "vault-demo"
    }
}

output "role-arn-vault" {
    description = "ARN of the vault-terraform role used for vault demo."
    value = module.iam_role-vault-terraform.arn
}