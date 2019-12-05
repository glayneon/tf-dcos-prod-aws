# It's local values for name-convension
locals {
  vpc-name          = "${var.name-prefix}"
  cluster-name      = "${var.name-prefix}-${var.aws-env}-${var.name-project}-tf"
  azs               = data.aws_availability_zones.available.names
}
