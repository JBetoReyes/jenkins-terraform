variable vpc_cidr_block {}
variable public_subnet_cidr_block {}
variable aws_region {}
variable instance_type {}
variable key_name {}
variable "bucket_name" {
    description = "jenkins bucket for script files"
}
variable "github_token" {
    description = "token to automate webhook initialization"
}