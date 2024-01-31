#Output to retrive VPC ID
output "vpc_id" {
  value = aws_vpc.vpc.id
}


#Output to retrive internet gateway ID
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

