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
variable "account_id" {
  default = "108791993403"
}
  

# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
  
# }
# variable "public_subnet_cidr" {
#   default = "10.0.1.0/24"
# }
# variable "private_subnet_cidr" {
#   default = "10.0.2.0/24"
  
# }
# variable "vpc_cidr_block" {
#   type    = string
#   default = "0.0.0.0/0"
# }

# variable "pattern_cdir_list" {
#   type    = list(string)
#   default = ["0.0.0.0/0"]
# }

# variable "from_port" {
#   default = 0
# }
# variable "to_port" {
#   default = 65535
# }
# variable "protocol" {
#   default = "tcp"
# }