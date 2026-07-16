# general vars
project            = "Pt1-Vault-Demo"
environment        = "dev"

# server vars
aws_region         = "us-east-1"

# vpc vars
az_zone            = "us-east-1a"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
ingress_cidr       = ["100.64.0.0/10"] # ["0.0.0.0/0"]

# vault
vault_addr         = "100.80.0.1"