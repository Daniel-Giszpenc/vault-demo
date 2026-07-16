terraform {
    required_providers {
        vault = {
            source  = "hashicorp/vault"
            version = "5.10.1"
        }
        sops = {
            source  = "carlpett/sops"
            version = "1.4.1"
        }
    }
}

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

