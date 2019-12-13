data "aws_vpc" "prod-eks" {
  tags = {
    Name = "${local.vpc-name}-vpc"
  }
}

data "aws_availability_zones" "az" {}

data "template_file" "log_name" {
  template = "${path.module}/output.log"
}

data "local_file" "update-vpc" {
  filename   = "${data.template_file.log_name.rendered}"
  depends_on = ["null_resource.update-vpc"]
}

output "aws-cli-output" {
  value = "${data.local_file.update-vpc.content}"
}

#data "aws_subnet_ids" "pri-subnets" {
#  vpc_id = data.aws_vpc.prod-eks.id
#
#  tags = {
#    Name = "${local.vpc-name}-private"
#  }
#}

#data "aws_subnet" "prod" {
#  count = "${length(data.aws_subnet_ids.pub-subnets.ids)}"
#  id    = "${tolist(data.aws_subnet_ids.pub-subnets.ids)[count.index]}"
#}

#output "subnet_cidr_blocks" {
#  value = "${data.aws_subnet.prod.*.cidr_block}"
#}

#data "aws_security_group" "cluster" {
#  vpc_id = data.aws_vpc.prod-eks.id
#  tags = {
#    Name = "${local.vpc-name}-eks-prod"
#  }
#}
#
#data "aws_security_group" "node" {
#  vpc_id = data.aws_vpc.prod-eks.id
#  tags = {
#    Name = "${local.vpc-name}-eks-prod-node"
#  }
#}
#
#data "aws_ami" "eks-worker-ami" {
#  filter {
#    name   = "name"
#    values = ["amazon-eks-node-${var.k8s-version}-*"]
#  }
#
#  most_recent = true
#  owners      = ["602401143452"] # Amazon
#}
