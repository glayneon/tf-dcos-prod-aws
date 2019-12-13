locals {
  # For storing result to logs
  logfile = data.template_file.log_name.rendered
  # Change vpc attribute is able to support 'enableDnsHostname' and 'enableDnsSupport' attributes.
  modify-vpc-attr1 = "aws ec2 modify-vpc-attribute --enable-dns-hostname --vpc-id=${local.vpc_id} --region=${var.aws-region}"
  modify-vpc-attr2 = "aws ec2 modify-vpc-attribute --enable-dns-support --vpc-id=${local.vpc_id} --region=${var.aws-region}"
  # Check those attributes is applied the specified vpc
  desc-vpc-attr1 = "aws ec2 describe-vpc-attribute --attribute=enableDnsHostnames --vpc-id=${local.vpc_id} --region=${var.aws-region}"
  desc-vpc-attr2 = "aws ec2 describe-vpc-attribute --attribute=enableDnsSupport --vpc-id=${local.vpc_id} --region=${var.aws-region}"
  # Tagging
  add-vpc-tag  = "aws ec2 create-tags --resources ${local.vpc_id} --region=${var.aws-region} --tags Key=kubernetes.io/cluster/${local.cluster-name},Value=shared"
  desc-vpc-tag = "aws ec2 describe-tags --filters 'Name=resource-id,Values=${local.vpc_id}'"
}
