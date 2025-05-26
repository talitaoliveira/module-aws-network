variable "env_name" = {
    type = string
}

variable "aws_region" = {
    type = string
}

variable "vpc_name" = {
    type = string
    default = "ms-up-running"
}

variable "main_vpc_cidr" = {
    type = string
}

variable "public_subnet_a_cirdr" = {
    type = string
}

variable "public_subnet_b_cirdr" = {
    type = string
}

variable "private_subnet_a_cirdr" = {
    type = string
}

variable "private_subnet_b_cirdr" = {
    type = string
}

variable "cluter_name" = {
    type = string
}