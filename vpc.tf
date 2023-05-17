module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


resource "aws_subnet" "lambda_subnet" {
  vpc_id     = module.vpc.vpc_id
  cidr_block = "${var.vpc_cidr_block_subnet}"
  tags = {
    Name = "Public Subnet - gabriel araujo"
  } 
}

resource "aws_security_group" "lambda_sg" {
    name        = "${var.app_env}-lambda-sg"
    description = "Allow inbound traffic"
    vpc_id      = module.vpc.vpc_id
    
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
