# Description: This file contains all the variables used in the project
variable "aws_region" {
  default = "us-east-1"
  description = "region to deploy to"
}
  
variable "aws_bucket" {
  default = "s3-sqs-terraform"
}
variable "app_env" {
  default = "project-terraform"
  description = "value for the environment tag"
}
variable "password" {
  default = "admin-gabriel"
  description = "password for the database RDS"
}
variable "username" {
  default = "admin"
}

variable "vpc_name" {
  default = "vpc_lambda_rds"
}
  
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_cidr_block_subnet" {
  default = "10.0.0.0/24"
}

variable "cloudwatch_log_group_name" {
  default = "lambda-rds-sqs-s3-tf"
}
  
variable "from_port" {
  default = 0
}
variable "to_port" {
  default = 65535
}
variable "protocol" {
  default = "tcp"
}