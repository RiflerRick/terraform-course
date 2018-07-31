provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}" # variables are accessed in this way
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}
