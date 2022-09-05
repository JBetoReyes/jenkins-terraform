variable "vpc_cidr_block" {
  description = "vpc CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "vpc CIDR block"
  default     = "10.0.0.0/24"
}

variable "private_eks_subnets_cidr_block" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.12.0/24"]
}

variable "public_eks_subnets_cidr_block" {
  type    = list(string)
  default = ["10.0.13.0/24", "10.0.14.0/24"]
}

variable "cluster_name" {}