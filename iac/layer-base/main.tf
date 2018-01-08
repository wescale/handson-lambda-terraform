
provider "aws" {
    region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "wescale-handson-serverless-terraform"
    region = "eu-west-1"
    key = "demo/layer-base"
  }
}

variable "region" {
    default = "eu-west-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
    description = "CIDR for the Public Subnet in a AZ"
    default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
    description = "CIDR for the Public Subnet in a AZ"
    default = "10.0.2.0/24"
}

variable "public_subnet_c_cidr" {
    description = "CIDR for the Public Subnet in a AZ"
    default = "10.0.3.0/24"
}

variable "private_subnet_a_cidr" {
    description = "CIDR for the Private Subnet in a AZ"
    default = "10.0.4.0/24"
}

variable "private_subnet_b_cidr" {
    description = "CIDR for the Private Subnet in a AZ"
    default = "10.0.5.0/24"
}

variable "private_subnet_c_cidr" {
    description = "CIDR for the Private Subnet in a AZ"
    default = "10.0.6.0/24"
}

