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
    region = "eu-de"
    ibmcloud_api_key = var.ibmcloud_api_key
}

data "ibm_resource_group" "group" {
  name = "Default"
}

data "ibm_container_cluster" "cluster" {
  name              = var.cluster_name
  resource_group_id = data.ibm_resource_group.group.id
}

data "ibm_container_cluster_config" "cluster" {
  cluster_name_id = var.cluster_name
  admin           = true
}