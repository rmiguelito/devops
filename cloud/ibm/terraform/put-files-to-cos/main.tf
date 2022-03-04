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
    region = "br-sao"
    ibmcloud_api_key = var.ibmcloud_api_key
}

data "ibm_resource_group" "cos_group" {
  name = "Default"
}

data "ibm_resource_instance" "cos_instance" {
  name              = "toolchain-object-storage"
  resource_group_id = data.ibm_resource_group.cos_group.id
  service           = "cloud-object-storage"
}

data "ibm_cos_bucket" "cos_bucket" {
  resource_instance_id = data.ibm_resource_instance.cos_instance.id
  bucket_name          = "helm-charts-bra"
  bucket_type          = "region_location"
  bucket_region        = "us-south"
}

resource "ibm_cos_bucket_object" "file" {
  bucket_crn      = data.ibm_cos_bucket.cos_bucket.crn
  bucket_location = data.ibm_cos_bucket.cos_bucket.region_location
  for_each = fileset("/home/miguel/vscode/helm-charts-pra/to-cos/", "*")
  content_file    = "/home/miguel/vscode/helm-charts-pra/to-cos/${each.value}"
  key             = "charts/${each.value}"
  etag = filemd5("/home/miguel/vscode/helm-charts-pra/to-cos/${each.value}")
}

### TODO ON NEW ACCOUNT // Create cos_instance and cos_bucket
# resource "ibm_resource_instance" "cos_instance" {
#   name              = "toolchain-object-storage"
#   resource_group_id = data.ibm_resource_group.cos_group.id
#   service           = "cloud-object-storage"
#   plan              = "standard"
#   location          = "global"
# }

# resource "ibm_cos_bucket" "cos_bucket" {
#   bucket_name           = "helm-charts-bra"
#   resource_instance_id  = ibm_resource_instance.cos_instance.id
#   region_location       = "us-south"
#   storage_class         = "standard"
# }
###

# resource "ibm_cos_bucket_object" "file" {
#   bucket_crn      = "crn:v1:bluemix:public:cloud-object-storage:global:a/a24d0093ce534932985d99f64aa9c537:ccd1e193-3628-4fb1-b870-b4862800183c:bucket:helm-charts-bra"
#   bucket_location = "us-south"
#   for_each = fileset("/home/miguel/vscode/helm-charts-pra/to-cos/", "*")
#   content_file    = "/home/miguel/vscode/helm-charts-pra/to-cos/${each.value}"
#   key             = "charts/${each.value}"
# }