#Provider value
region = "us-east-1"

#VPC module value
vpc_cidr = "10.0.0.0/16"

#Subnet module value
subnet = { 
      subnet_cidr       = "10.0.0.0/24"
      availability_zone = "us-east-1a" 
      }
     
#EC2 module value
public_key_path = "~/.ssh/ivolve.pub"
ec2_ami_id 	= "ami-0c7217cdde317cfec" #ubuntu AMI
ec2_type  	= "m5.large"

#CloudWatch module value
sns_email = "ibrahimadel1010@gmail.com"
