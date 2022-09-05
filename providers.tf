provider "aws" {
  region = "us-west-1"
}

terraform {

  required_providers {
    aws = {}
  }

  required_version = "1.2.7"

  backend "s3" {
    bucket               = "jenkins-tf-beto-2022"
    key                  = "infra.json"
    region               = "us-west-1"
    workspace_key_prefix = "environment"
  }
}