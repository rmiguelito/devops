terraform {
  backend "s3" {
    bucket = "terraform-state-rmiguel"
    key = "terraform-aws.tfstate"
    region = "us-east-1"
  }
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.27"
      }
  }
}

provider "aws" {
    region = "us-east-1"
    profile = "default"
}

resource "aws_instance" "app_server" {
    ami = "ami-04505e74c0741db8d"
    instance_type = "t2.micro"
    tags = {
        Name = var.instance_name
 }
}