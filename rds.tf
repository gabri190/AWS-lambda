resource "aws_db_instance" "database_lambda" {
  allocated_storage    = 10

  db_name              = "database_lambda"
  identifier           = "mysql-db-lambda"
  
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  username             = "${var.username}"
  password             = "${var.password}"
  parameter_group_name = "default.mysql8.0"
  
  skip_final_snapshot  = true
  publicly_accessible = true
  copy_tags_to_snapshot = true
  max_allocated_storage = 1000
  vpc_security_group_ids = [aws_security_group.lambda_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}
#create a private subnet group for the database
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "subnet_group_rds "
  subnet_ids = module.vpc.private_subnets
}




