module "my-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster-name
  subnets      = data.aws_subnet_ids.pub-subnets.ids
  vpc_id       = data.aws_vpc.prod-eks.id

  worker_groups = [
    {
      instance_type = "t2.large"
      asg_max_size  = 5
      asg_desired_capacity = 3
    }
  ]

  tags = {
    environment = "test"
  }
}
