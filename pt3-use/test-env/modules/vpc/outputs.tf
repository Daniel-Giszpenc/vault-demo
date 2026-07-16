# Outputs for integration with other components
output "vpc_id" {
    description = "ID of the created VPC"
    value       = aws_vpc.Terraform_VPC.id
}

output "server_subnet_id" {
    description = "IDs of all public subnets"
    value       = aws_subnet.Terraform_VPC-pub.id
}

output "security_group_id" {
    description = "Security group used for servers in private subnet"
    value       = aws_security_group.main.id
}

output "server_eip_id" {
    description = "EIP used by the public server."
    value       = aws_eip.server.id
}

output "server_eip_address" {
    description = "Server EIP address used for DNS A records."
    value       = aws_eip.server.address
}