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

variable "cloudwatch_log_group_name" {
  default = "lambda-rds-sqs-s3-tf"
}
variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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