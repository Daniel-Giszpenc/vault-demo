terraform {
    required_version = ">= 1.0"
    required_providers {
        vault = {
            source  = "hashicorp/vault"
            version = "~> 5.10.1"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "6.55.0"
        }
        cloudinit = {
            source  = "hashicorp/cloudinit"
            version = "2.4.0"
        }
        sops = {
            source  = "carlpett/sops"
            version = "1.4.1"
        }
    }
}



### Auth ###

data "sops_file" "sops-secret" {
    source_file = "../../secret-scratchpad/secrets.yaml"
}

resource "local_file" "vault_ca_cert" {
    content  = data.sops_file.sops-secret.data["vault_crt"] # Or access a specific key like data.sops_file.vault_cert.data["cert_content"]
    filename = "${path.module}/vault.crt"
}

provider "vault" {
    address       = "https://100.80.0.1:8200"
    ca_cert_file  = local_file.vault_ca_cert.filename
    token         = data.sops_file.sops-secret.data["vault_token"]
}

# provider "vault" {
#     address = var.vault_addr
#     auth_login_oidc {
#         role = "github-role"
#     }
# }

ephemeral "vault_aws_access_credentials" "aws_creds" {
    mount   = "aws"
    role    = "vault-terraform"
}

provider "aws" {
    region     = var.aws_region
    # These come dynamically from the ephemeral resource
    access_key = tostring(ephemeral.vault_aws_access_credentials.aws_creds.access_key)
    secret_key = tostring(ephemeral.vault_aws_access_credentials.aws_creds.secret_key)
    token      = tostring(ephemeral.vault_aws_access_credentials.aws_creds.security_token)

    // default_tags don't interact with api in same way
    // as tags at the resource block level so they are
    // nice for console filtering but not IAM condition filtering
    default_tags {
        tags = {
            Project-DefaultTag     = var.project
            Environment-DefaultTag = var.environment
        }
    }
}

data "vault_kv_secret_v2" "aws_server_ts_auth_key" {
    mount = "infra-secrets"
    name  = "tailscale_aws_auth_key"
}

module "network" {
    source             = "./modules/vpc"
    project            = var.project
    az_zone            = var.az_zone 
    vpc_cidr           = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    ingress_cidr       = ["0.0.0.0/0"] # ["100.64.0.0/10"]
}

module "server" {
    source             = "./modules/server"
    project            = var.project
    tailscale_auth_key = data.vault_kv_secret_v2.aws_server_ts_auth_key.data["key"]
    aws_region         = "us-east-1"
    server_subnet_id   = module.network.server_subnet_id
    security_group_id  = module.network.security_group_id
    server_eip_id      = module.network.server_eip_id
}
