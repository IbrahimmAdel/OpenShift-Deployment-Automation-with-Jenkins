variable "vpc_id" {
  description = "ID of the vpc in where the subnets will be"
  type        = string
}


variable "subnet" {
  description = "subnet info"
  type	      = object({
    subnet_cidr       = string
    availability_zone = string
  })
}


variable "igw_id" {
  description = "ID of the IGW to be used in route table for public subnets"
  type 	      = string
}
