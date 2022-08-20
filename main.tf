module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
}

module "security_group" {
   source = "./modules/security_group"
   vpc_id = module.vpc.vpc_id
}

module "bucket" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

module "ec2_instance" {
   source = "./modules/compute"
   security_group = module.security_group.sg_id
   public_subnet = module.vpc.public_subnet_id
   bucket_name = module.bucket.bucket_name
   aws_region = var.aws_region
   instance_type = var.instance_type
   key_name = var.key_name
}