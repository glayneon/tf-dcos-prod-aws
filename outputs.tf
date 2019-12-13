output "vpc-id" {
  value = data.aws_vpc.prod-eks.id
}

output "vpc-cidr" {
  value = data.aws_vpc.prod-eks.cidr_block
}

output "vpc-enable-dns-support" {
  value = data.aws_vpc.prod-eks.enable_dns_support
}

output "vpc-enable-dns-hostnames" {
  value = data.aws_vpc.prod-eks.enable_dns_hostnames
}

output "pub-subnets-id" {
  value = data.aws_subnet_ids.pub-subnets.ids
}

#output "cluster-sg" {
#  value = data.aws_security_group.cluster.id
#}

#output "node-sg" {
#  value = data.aws_security_group.node.id
#}
