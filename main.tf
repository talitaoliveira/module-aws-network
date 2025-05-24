provider "aws" {
    region = var.aws_region
}

locals {
    vpc_name = "${var.env_name} ${var.vpc_name}"
    cluster_name = "${var.cluster_name}-${var.env_name}"
}

## AWS VPC definition
resource "aws_vpc" "main" {
    cidr_block = var.main_vpc_cidr
    tags = {
        "Name"                                          = local.vpc_name,
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
    }
}

# subnet definition

data "aws_availability_zones" "available" { # "Asking" AWS for AZ IDs in the region we specified
    state = "available"
}

resource "aws_subnet" "public-subnet-a" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.public_subnet_a_cidr
    availability_zone   = data.aws_availability_zones.available.names[0]

    tags = {
        "Name"                                          = (
            "${local.vpc_name}-public-subnet-a"
        )
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
        "kubernetes.io/role/elb"                        = 1
            
    }
}

resource "aws_subnet" "public-subnet-b" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.public_subnet_b_cidr
    availability_zone   = data.aws_availability_zones.available.names[1]

    tags = {
        "Name"                                          = (
            "${local.vpc_name}-public-subnet-b"
        )
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
        "kubernetes.io/role/elb"                        = 1
            
    }
}

resource "aws_subnet" "private-subnet-a" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet_a_cidr
    availability_zone   = data.aws_availability_zones.available.names[0]

    tags = {
        "Name"                                          = (
            "${local.vpc_name}-private-subnet-a"
        )
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
        "kubernetes.io/role/internal-elb"               = 1
            
    }
}

resource "aws_subnet" "private-subnet-b" {
    vpc_id              = aws_vpc.main.id
    cidr_block          = var.private_subnet_b_cidr
    availability_zone   = data.aws_availability_zones.available.names[1]

    tags = {
        "Name"                                          = (
            "${local.vpc_name}-private-subnet-b"
        )
        "kubernetes.io/cluster/${local.cluster_name}"   = "shared"
        "kubernetes.io/role/internal-elb"               = 1
            
    }
}

# Internet gateway and routing tables for public subnets

resource "aws_internet_gateway" "igw" { # Creates the internet gatweay name igw
    vpc_id = aws_vpc.main.id # attached to the VPC previously created

    tags = {
        "Name" = "${local.vpc_name}-igw"
    }
}

resource "aws_route_table" "public_route" { # Creates a route table named public_route
    vpc_id = aws_vpc.main.id # attached to the VPC previously created

    route {
        cidr_block = "0.0.0.0/0" # matches all IP addresses (entire internet)
        gateway_id = aws_internet_gateway.igw.id # sends the traffic to the Internet Gateway previously created
    }

    tags = {
        "Name" = "${local.vpc_name}-public-route"
    }
}

resource "aws_route_table_association" "public-a-association" {
    subnet_id = aws_subnet.public-subnet-a.id
    route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "public-b-association" {
    subnet_id = aws_subnet.public-subnet-b.id
    route_table_id = aws_route_table.public-route.id
}
