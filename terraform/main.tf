provider "aws" {
  region = "eu-central-1"
}

# VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Security Group
resource "aws_security_group" "demo_sg" {
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "demo_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 AMI for eu-central-1
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  tags = {
    Name = "DemoInstance"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "demo_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"         # Corrected from 'name' to 'db_name'
  username             = "admin"
  password             = "password"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  # Additional required arguments
  skip_final_snapshot   = true
  publicly_accessible   = true
  multi_az              = false
}

