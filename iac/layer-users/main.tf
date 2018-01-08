
provider "aws" {
    region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "demo-handson-serverless-terraform"
    region = "eu-west-1"
    key = "demo/layer-demo"
  }
}

data "terraform_remote_state" "layer_base" {  
 backend = "s3"
 config {
    bucket = "wescale-handson-serverless-terraform"
    region = "eu-west-1"
    key = "demo/layer-base"
 }
}

variable "version_users" {
  description = "version of users service"
  default = "beta"
}

variable "region" {
  default = "eu-west-1"
}

variable "account_id" {
  default = "256964442513"

}