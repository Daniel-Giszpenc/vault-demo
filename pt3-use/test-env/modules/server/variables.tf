variable "project" {
    type        = string
    description = "Project name for tags"
    default     = "Personal-Website"
}

variable "tailscale_auth_key" {
    description = "Node authorization key; if it begins with 'file:', then it's a path to a file containing the authkey"
    type        = string
    sensitive   = true
}

variable "aws_region" {
    description = "AWS region"
    type        = string
}

variable "server_subnet_id" {
    description = "ID of the subnet the server will be placed in"
    type        = string
}

variable "security_group_id" {
    description = "Security group used by server"
    type        = string
}

variable "server_eip_id" {
    description = "EIP used by server"
    type        = string
}