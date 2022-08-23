variable "security_group" {
    description = "The security group of your jenkins server"
}

variable "aws_region" {
    description = "The AWS region we are deploying in"
}

# Variable where we will pass in the subnet ID
variable "public_subnet" {
    description = "The public subnet for the Jenkins server"
}

variable "instance_type" {
    description = "The instance type"
}

variable "key_name" {
    description = "Instance Key Name"
}

variable "bucket_name" {
    description = "Jenkins bucket name"
}

variable "github_token" {
    description = "token to automate webhook initialization"
}
variable docker_hub_user {}
variable docker_hub_password {}