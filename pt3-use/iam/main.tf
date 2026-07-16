terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.28.0"
        }
    }
}

provider "aws" {
    assume_role {
        // made via click-ops to bootstrp
        # role_arn     = "arn:aws:iam::767398065040:role/bootstrap-terraform-iam"
        // created from this module and added arn here by hand
        role_arn     = "arn:aws:iam::767398065040:role/iam-controller-20260126191404497000000006"
        session_name = "terraform-personal-website-map"
    }

    region = "us-east-1"
}
