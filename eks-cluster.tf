module "my-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster-name
  #subnets                         = data.aws_subnet_ids.pri-subnets.ids
  subnets                         = aws_subnet.private.*.id
  vpc_id                          = local.vpc_id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  worker_groups = [
    {
      instance_type        = "t2.large"
      asg_max_size         = 5
      asg_desired_capacity = 3
    }
  ]

  tags = {
    environment = "test"
  }
}
