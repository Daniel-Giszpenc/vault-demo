resource "vault_mount" "kv_v2" {
    path        = "dev-secrets"
    type        = "kv-v2"
    description = "KV Version 2 secrets engine for application secrets"

    options = {
        version = "2"
    }
}

resource "vault_mount" "kv_v2_infra_secrets" {
    path        = "infra-secrets"
    type        = "kv-v2"
    description = "KV Version 2 secrets engine for application secrets"

    options = {
        version = "2"
    }
}

resource "vault_policy" "developer_policy" {
    name   = "developer-access"
    policy = <<EOT
    path "dev-secrets/*" {
        capabilities = ["create", "read", "update", "delete", "list"]
    }
    EOT
}

resource "vault_kv_secret_v2" "secret_msg" {
    mount     = "dev-secrets"
    name      = "app/bad_message_example"
    data_json = jsonencode({
        msg = "bad idea putting this here :)"
    })
}
