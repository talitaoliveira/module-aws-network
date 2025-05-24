provider "aws" {
    region = var.aws_region
}

locals {
    vpc_name = "${var.env_name} ${var.vpc_name}"
    cluster_name = "${var.cluster_name} ${var.env_name}"
}

## AWS VPC definition
resource "aws_vpc" "main" {
    cidr_block = var.main_vpc_cidr
    tags = {
        "Name"                                          = local.vpc_name,
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
    }
}