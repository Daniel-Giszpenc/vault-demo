# Public Route Table with route to Internet Gateway
resource "aws_route_table" "Terraform_VPC-pub-RT" {
    vpc_id = aws_vpc.Terraform_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Terraform_VPC-IGW.id
    }

    tags = {
        Name    = "Terraform_VPC-pub-RT"
        Project = var.project
    }
}

# Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "Terraform_VPC-pub" {
    subnet_id      = aws_subnet.Terraform_VPC-pub.id
    route_table_id = aws_route_table.Terraform_VPC-pub-RT.id
}