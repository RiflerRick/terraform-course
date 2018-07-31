## Infrastructure as code

Terraform keeps the infrastructure as a certain state. Terraform will always match its code with the infrastructure. It also makes the infrastructure auditable because we can actually maintain it as code in a repository.
 
```bash
terraform init # for initialization
```

after initialization we can use the following command to see the changes that will be applied
```bash
terraform plan
```

we can finally use the following command to apply the changes made
```bash
terraform apply # apply lets us review the changes before actually applying them
```

Another useful command to destroy the infrastructure would be
```bash
terraform destroy
```

It is possible to store the configuration that will be applied using the `-out` parameter of `terraform plan` in the following way
```bash
terraform plan -out out.terraform
```

We can then do
```bash
terraform apply out.terraform
```

Basically here the changes that will be made(basically the diff) will be stored in the file out.terraform.
So basically `terraform apply` is a shortcut of the following command
```bash
terraform plan -out file; terraform apply file; rm file
```

In production environments it is highly recommended to store the output in an out file and then apply on that out file.

### Variables in terraform

- use variables to hide secrets for instance

### Provisioning software

For software provisioning the following things can be done:
- Chef is integrated with terraform and therefore it is possible to add chef statements with terraform
- It is possible to run puppet agents using remote-exec
- For ansible, it is possible to first run terraform and output the ip addresses and then run ansible-playbook on them

This entire thing can be automated in a workflow script so we can first run terraform and then an ansible script for software provisioning

For software provisioning terraform provides `File uploads`.

### Remote State

terraform stores the current state of the infrastructure in a `.tfstate` file. This file is locally available and can be saved to git, however a better solution than a local state is a remote state. A remote state may be stored in s3 for instance in dynamodb. In case of s3 it also provides a locking mechanism. 

### Datasources

For certain providers(like AWS), terraform provides datasources, datasources provides us with dynamic information. A lot of data is available in aws in a structured format using their apis. terraform also exposes this information using datasources. for example the list of AMIs and the list of availability zones. 

### Modules

Modules: essentially for grouping just like in normal programming

It is also possible to use modules from git in the following way.

```hcl-terraform
module "module-example" {
  source = "github.com/wardviaene/terraform-module-example"
}
```
or modules from local folders
```hcl-terraform
module "module-example" {
  source = "./module-example"
}
```
it is also possible to pass arguments to a module
```hcl-terraform
module "module-example" {
  source = "./module-example"
  region = "us-west-1"
  ip-range = "10.0.0.0/8"
  cluster-size = "3"
}
```

Inside the `module-exmaple` folder we can actually have whole modules in the following way:

module-example/vars.tf
```hcl-terraform
variable "region" {} //these are the input parameter
variable "ip-range" {}
variable "cluster-size" {}
```

module-example/cluster.tf
```hcl-terraform
resource "aws_instance" "ins-1" {}
resource "aws_instance" "ins-2" {}
resource "aws_instance" "ins-3" {}
```

The `module-example` folder can actually have many different terraform files. In the main code where we are actually calling the module using the `module` keyword, we can use `output`s from various modules and do other things with them. For instance in the `module-example/output.tf` file we may have the following code
```hcl-terraform
output "aws-cluster" {
  value = "${aws_instance.ins-1.public_ip},${aws_instance.ins-2.public_ip},${aws_instance.ins-3.public_ip}"
}
```
We can now use this output in the main code.