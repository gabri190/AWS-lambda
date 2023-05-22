resource "aws_vpc" "lambda_rds_vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "lambda_rds_vpc - gabriel araujo"
  }
}



resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.lambda_rds_vpc.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Private Subnet - gabriel araujo"
  }
}
locals {
    private_subnet_cidrs = [
      "10.0.0.0/24",
      "10.0.1.0/24",
      "10.0.2.0/24"
  ]
}


resource "aws_security_group" "lambda_sg" {
    name        = "${var.app_env}-lambda-sg"
    description = "Allow inbound traffic"
    vpc_id      = aws_vpc.lambda_rds_vpc.id
    
    ingress {
        from_port   = var.from_port
        to_port     = var.to_port
        protocol    = "${var.protocol}"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port = var.from_port
    to_port   = var.to_port
    protocol  = "${var.protocol}"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
