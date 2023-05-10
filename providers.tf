provider "aws" {
  region = var.aws_region
  version = ">= 3.0"
  
  # timeouts {
  #   create = "30m"
  #   update = "60m"
  #   delete = "30m"
  # }
}
  