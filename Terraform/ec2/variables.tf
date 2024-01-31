variable "sg_vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}


variable "public_key_path" {
  description = "path of public key which will be used in EC2 key pair"
  type 	      = string
}


variable "ec2_ami_id" {
  description = "ID of the EC2 instance AMI"
  type 	      = string
}


variable "ec2_type" {
  description = "Type of the EC2 instance"
  type 	      = string
}


variable "ec2_subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
}
