#Create security group
resource "aws_security_group" "sg" {
  vpc_id = var.sg_vpc_id

  ingress {
    from_port   = 443      #HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80       #HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22       #SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080     #Jenkins
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 9000     #SonarQubr
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "iVolve_sg"
  }
}


#Create Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "iVolve-key-pair"
  public_key = file(var.public_key_path)
}


#Launch EC2 instances
resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_type
  subnet_id                   = var.ec2_subnet_id   
  key_name                    = aws_key_pair.key_pair.key_name  
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = true
  
  tags = {
      Name = "iVolve-ec2"
    } 
}
