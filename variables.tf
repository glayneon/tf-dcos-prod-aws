# Variables Configuration

# Project Name Prefix and sufix variables from Chase
variable "name-project" {
  description = "the name for this project"
  default     = "eks"
}

variable "aws-env" {
  description = "the AWS environment"
  default     = "prod"
}

variable "name-prefix" {
  description = "the name prefix for AIOps"
  default     = "dcos"
}

variable "aws-region" {
  default     = "ap-northeast-2"
  type        = string
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.14"
  type        = string
  description = "Required K8s version"
}

variable "vpc_pri_suffix" {
  default = "10.241.1"
  type    = string
}

variable "vpc_pub_suffix" {
  default = "10.241.11"
  type    = string
}
