variable "project" {
    type        = string
    description = "Project name for tags"
}

variable "environment" {
    type        = string
    description = "Environment name for tags"
}

# AWS region where resources will be created.
variable "aws_region" {
    type = string
    description = "AWS region for all resources"
}

variable "az_zone" {
  type        = string
  description = "Public subnet AZ zone in AWS region"
}

variable "vpc_cidr" {
    description = "Primary CIDR block for the VPC"
    type        = string
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet in which the server resides."
    type        = string
}

variable "ingress_cidr" {
    description = "CIDR block for allowed ingress to open ports."
    type        = list(string)
}

variable "vault_addr" {
    type      = string
    sensitive = true
}