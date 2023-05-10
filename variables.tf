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

  
#variable acoount_id 
variable "account_id" {
  default = "id=108791993403"
  description = "account id"
}
#variable user name
variable "user_name" {
  default = "gabrielaa3"
  description = "user name"
}