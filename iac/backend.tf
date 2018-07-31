terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform/sample-project"
    region = "ap-south-1"
  }
}

// it is also possible to have declare a read-only remote store directly in the .tf file
// in the following way

// this is actually a datasource

//data "terraform_remote_state" "aws-state" {
//  backend = "s3"
//  config {
//    bucket = "terraform-state"
//    key = "terraform.tfstate"
//    access_key = "${var.AWS_ACCESS_KEY}"
//    access_secret = "${var.AWS_SECRET_KEY}"
//    region = "${var.AWS_REGION}"
//  }
//}
