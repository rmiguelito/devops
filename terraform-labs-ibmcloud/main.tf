terraform {
  backend "s3" {
    bucket = "terraform-state-rmiguel"
    key = "terraform-ibmcloud.tfstate"
    region = "us-east-1"
  }
  required_providers {
    ibm = {
        source = "IBM-Cloud/ibm"
        version = "~> 1.37.1"
    }
  }
}

provider "ibm" {
    region = "us-south"
    ibmcloud_api_key = var.ibmcloud_api_key
}

resource "ibm_iam_user_invite" "invite_user" {
  for_each = toset(var.users_to_invite)
  users = [each.key]
}