#Provider variable
variable "region" {
  description = "AWS region"
  type	      = string
  default     = "us-east-1"  
}


#VPC module variable
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}


#Subnet module variable
variable "subnet" {
  description = "Subnet info"
  type        = object({
    subnet_cidr       = string
    availability_zone = string
  })
  default = {
    subnet_cidr       = "10.0.0.0/24"
    availability_zone = "us-east-1a"
  }
}


#EC2 module variable
variable "public_key_path" {
  description = "path of public key which will be used in EC2 key pair"
  type 	      = string
  default     = "~/.ssh/ivolve.pub"
}

variable "ec2_ami_id" {
  description = "ID of the EC2 instance AMI"
  type        = string
  default     = "ami-0c7217cdde317cfec" #ubuntu AMI
}

variable "ec2_type" {
  description = "ec2 instance type"
  type        = string
  default     = "m5.large"
}


#CloudWatch module variable
variable "sns_email" {
  description = "email that will recieve mails from SNS"
  type        = string
}

