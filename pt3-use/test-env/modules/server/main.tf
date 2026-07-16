# module "tailscale_cloudinit" {
#     source  = "github.com/tailscale/terraform-cloudinit-tailscale"
#     auth_key       = var.tailscale_auth_key
#     enable_ssh     = true
#     hostname       = "aws-server"
#     advertise_tags = ["tag:aws-server"]
# }

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t3a.nano" # $3.43 a month on-demand
    subnet_id              = var.server_subnet_id
    vpc_security_group_ids = [var.security_group_id]

    ebs_optimized = true

    # not using tailscale cloud-init module because it doesn't
    # provide raw yaml to merge with my custom cloud-init script
    user_data = templatefile("${path.module}/../../../cloud_init/server_conf.yml", {
        tailscale_auth_key    = var.tailscale_auth_key
        tailscale_server_name = "aws-web-server"
    })

    # user_data = module.tailscale_cloudinit.rendered

    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"
    }

    tags = {
        Name    = "user-data-tailscale-ubuntu"
        Project = var.project
    }
}

resource "aws_eip_association" "instance" {
    instance_id   = aws_instance.web.id
    allocation_id = var.server_eip_id
}
