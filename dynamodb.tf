resource "aws_dynamodb_table" "dynamodb_table" {
  name             = "dynamobdb-table"
  hash_key         = "TestTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "TestTableHashKey"
    type = "S"
  }
  depends_on = [aws_vpc_endpoint.dynamodb_endpoint]
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id       = "${aws_vpc.lambda_rds_vpc.id}"
  service_name =  "com.amazonaws.us-east-1.dynamodb"

}
