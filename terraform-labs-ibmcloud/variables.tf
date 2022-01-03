variable "ibmcloud_api_key" {
  description = "The API key for the IBM Cloud account."
  default = ""
}

variable "users_to_invite" {
  description = "The list of users to invite to the ibm."
  type = list(string)
  default = ["user1", "user2", "user3"]
}