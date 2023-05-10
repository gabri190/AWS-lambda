module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
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

# # Create an internet gateway and attach it to the VPC
# resource "aws_internet_gateway" "my_igw" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "my-igw"
#   }
# }

# # Create a route table for the public subnet
# resource "aws_route_table" "public_rt" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.my_igw.id
#   }

#   tags = {
#     Name = "public-rt"
#   }
# }
resource "aws_security_group" "lambda_sg" {
    name        = "${var.app_env}-lambda-sg"
    description = "Allow inbound traffic"
    vpc_id      = module.vpc.vpc_id
    
    ingress {
        description = "Allow inbound traffic"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
