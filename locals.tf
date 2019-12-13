# It's local values for name-convension
locals {
  vpc-name          = "${var.name-prefix}"
  cluster-name      = "${var.name-prefix}-${var.aws-env}-${var.name-project}-tf"
  azs               = data.aws_availability_zones.available.names
  temp_file = data.template_file.log_name.rendered
  modify-vpc-attr1 = "aws ec2 modify-vpc-attribute --enable-dns-hostname --enable-dns-support --vpc-id ${data.aws_vpc.prod-eks.id}"
  modify-vpc-attr2 = "aws ec2 modify-vpc-attribute --enable-dns-support --vpc-id ${data.aws_vpc.prod-eks.id}"
  modify-subnet-attr1 = "aws ec2 modify-subnet-attribute --subnet-id ${data.dddd} --map-public-ip-on-launch"
  desc-vpc-attr1 = "aws ec2 describe-vpc-attribute --attribute=enableDnsHostnames --vpc-id= > ${data.template_file.log_name.rendered}"
  desc-vpc-attr2 = "aws ec2 describe-vpc-attribute --attribute=enableDnsSupport --vpc-id= > ${data.template_file.log_name.rendered}"
  desc-subnet-attr = "aws ec2 describe-subnets --filters 'Name=vpc-id,Values=${data.aws_vpc.prod-eks.id}'"
}
