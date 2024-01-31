provider "aws" {
  region             = var.region
}

module "vpc" {
  source             = "./vpc"
  vpc_cidr           = var.vpc_cidr
}

module "subnet" {
  source             = "./subnet"
  vpc_id             = module.vpc.vpc_id
  subnet             = var.subnet
  igw_id             = module.vpc.igw_id
}

module "ec2" {
  source             = "./ec2"
  sg_vpc_id          = module.vpc.vpc_id
  public_key_path    = var.public_key_path
  ec2_ami_id	     = var.ec2_ami_id
  ec2_type  	     = var.ec2_type
  ec2_subnet_id      = module.subnet.subnet_id
}

module "cloudwatch" {
  source             = "./cloudwatch"
  ec2_id	     = module.ec2.ec2_id
  cloudwatch_region  = var.region
  sns_email	     = var.sns_email
}

#Output to retrive EC2 instance public IP
output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}
