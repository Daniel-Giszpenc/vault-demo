# Storage backend configuration using integrated storage (Raft)
# Raft is HashiCorp's recommended production backend and supports HA and snapshots
storage "raft" {
  path    = "/vault/data"
  node_id = "vault-1"
}

# HTTP listener configuration
# In production, always use TLS with proper certificates
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "false"
  tls_cert_file = "/vault/certs/vault.crt"
  tls_key_file  = "/vault/certs/vault.key"
}

# API address that Vault advertises to clients
api_addr = "https://vault:8200"

# Cluster address for high availability setups
cluster_addr = "https://vault:8201"

# Disable memory locking if running in containers without IPC_LOCK capability
disable_mlock = true

# UI configuration - enable the web interface
ui = true

# Telemetry configuration for monitoring
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}