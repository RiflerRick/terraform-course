resource "aws_key_pair" "rajdeep-key" {
  key_name   = "ssh-key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

// for logging into any aws instance, we need to have a resource of type aws_key_pair first, we can give it our public key

resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"  # a lookup field essentially looks up a map
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.rajdeep-key.key_name}"

//   provisioners are
  provisioner "file" {
    source      = "script.sh"      // basically an easy way to upload a file
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/scrit.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.private_ip} >> private_ips.txt"

//     a local-exec script does not run the command in the ec-instance, it rather runs it locally in the local machine
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"

//     password    = "${var.instance_password}" # password is the alternative to private_key
  }

//   when spinning up instances on AWS, ec2-user is the default user for amazon linux and ubuntu for ubuntu linux
//   file upload can be used in conjunction with remote-exec to execute a script on the machine that we are provisioning
//   for remote accessing the machines ssh is used for linux and so we need to have the connection tag with a user and a password
}

output "ip" {
  value = "${aws_instance.example.public_ip}" # outputs the public ip of the aws_instance generated

//   it is possible to refer to any attribute by specifying the following variables:
//   resource_type which in our case is aws_instance
//   resource_name which in our case is example
//   attribute name which in our case is public_ip

//   it is also totally possible to use these attributes in a script. For instance if we have a local-exec block that can run a command locally, we can use the attribute value in that
}
