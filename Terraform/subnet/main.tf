#Create subnet
resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet.subnet_cidr
  availability_zone = var.subnet.availability_zone
  tags = {
    Name = "iVolve-subnet"
  }
}


#Create route table 
resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = {
    Name = "iVolve-route-table"
  }
}


#Assign route table to subnet
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}
