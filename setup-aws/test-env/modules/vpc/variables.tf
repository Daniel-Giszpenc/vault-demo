variable "project" {
    type        = string
    description = "Project name for tags"
}

variable "az_zone" {
    type        = string
    description = "AZ zone in AWS region"
}

variable "vpc_cidr" {
    type        = string
    description = "What cidr block is used for the VPC as a whole."
}

variable "public_subnet_cidr" {
    type        = string
    description = "What cidr is used for the public subnet."
}

// useful for controlling private dev progression env access and public prod progression env access
variable "ingress_cidr" {
    type        = list(string)
    description = "What cidr block is matched in security group ingress rules for ports 80 and 443 access."
}