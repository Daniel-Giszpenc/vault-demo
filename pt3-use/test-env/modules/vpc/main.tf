# Create a VPC with DNS support and hostnames enabled
resource "aws_vpc" "Terraform_VPC" {
    cidr_block           = var.vpc_cidr
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name    = "Terraform_VPC"
        Project = var.project
    }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "Terraform_VPC-IGW" {
    vpc_id = aws_vpc.Terraform_VPC.id
    tags = {
        Name    = "Terraform_VPC-IGW"
        Project = var.project
    }
}

# Public Subnet
resource "aws_subnet" "Terraform_VPC-pub" {
    vpc_id                  = aws_vpc.Terraform_VPC.id
    cidr_block              = var.public_subnet_cidr
    map_public_ip_on_launch = "true"   # Enable public IP assignment
    availability_zone       = var.az_zone
    tags = {
        Project = var.project
    }
}

# Server elastic ip
resource "aws_eip" "server" {
    domain = "vpc"
    tags = {
        Name    = "server-eip"
        Project = var.project
    }
}

resource "aws_security_group" "main" {
    vpc_id      = aws_vpc.Terraform_VPC.id
    description = "Tailscale required traffic"

    # No ingress SSH rules needed - Tailscale handles SSH access
    ingress {
        from_port   = 41641
        to_port     = 41641
        protocol    = "udp"
        cidr_blocks = ["100.64.0.0/10"]
        description = "Tailscale UDP port"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = var.ingress_cidr
        description = "HTTP"
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = var.ingress_cidr
        description = "HTTPS"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

    tags = {
        Name    = "progession-env-flexible-sg"
        Project = var.project
    }
}