# #S3 bucket
# resource "aws_s3_bucket" "bucket" {
#   bucket = "${var.app_env}-s3-sqs-demo-bucket"
  
#   tags = {
#     Environment = var.app_env
#   }
# }
# #S3 event filter
# resource "aws_s3_bucket_notification" "bucket_notification" {
#   bucket = aws_s3_bucket.bucket.id
#   queue {
#     queue_arn     = aws_sqs_queue.queue.arn
#     events        = ["s3:ObjectCreated:*"]
#     }
# }
# #event source from SQS
# resource "aws_lambda_event_source_mapping" "sqs_event_source" {
#   event_source_arn = aws_sqs_queue.queue.arn
#   function_name    = aws_lambda_function.lambda_function.arn
#   batch_size       = 1
# }