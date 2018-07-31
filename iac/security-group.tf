data "aws_ip_ranges" "european_ec2" {
  regions = ["eu-west-1", "eu-central-1"]
  services = ["ec2"]
}

// data refers to a datasource. Here the datasource will store all the ips from the regions specified of all ec2 services.
// datasources are used for dynamic data which means if the ip ranges change then the next time we do terraform apply the datasource will automatically take the latest value

resource "aws_security_group" "from_europe" {
  name = "from_europe"
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["${data.aws_ip_ranges.european_ec2.cidr_blocks}"]
  }
//  this will create a security group that will allow all ip ranges coming from the data source
//  if the ips change then after the change we can do a terraform apply and that will change the security groups again
  tags {
    CreateDate = "${data.aws_ip_ranges.european_ec2.create_date}}"
    SyncToken = "${data.aws_ip_ranges.european_ec2.sync_token}"
  }
}