# It's local values for name-convension
locals {
  vpc-name     = "${var.name-prefix}-${var.aws-env}"
  cluster-name = "${var.name-prefix}-${var.aws-env}-${var.name-project}1"
  azs          = data.aws_availability_zones.az.names
  vpc_id       = data.aws_vpc.prod-eks.id
}
