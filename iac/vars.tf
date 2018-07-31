variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = "map" # map type variable for AMIS

  default = {
    us-east-1 = "ami-8f141cf0"
    us-west-2 = "ami-01f5ad79"
    eu-west-1 = "ami-f449ac19"
  }
}

variable "INSTANCE_USERNAME" {}
variable "PATH_TO_PUBLIC_KEY" {}
variable "PATH_TO_PRIVATE_KEY" {}
