#data resource to archive the bucket
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

#Lambda function policy
resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_policy_"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = "${aws_s3_bucket.bucket.arn}"
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ]
        Effect = "Allow"
        Resource = "${aws_sqs_queue.queue.arn}"
      },
    ]
  })
}

#lambda function role
resource "aws_iam_role" "lambda_role" {
    name = "${var.app_env}-lambda_role"
    assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
                "Effect": "Allow",
            "Sid": ""
            }
        ]   
    }
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_policy.arn
}

#lambda function
resource "aws_lambda_function" "lambda_function" {
    filename      = "${path.module}/lambda.zip"
    function_name = "${var.app_env}-lambda-function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "index.handler"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime       = "python3.8"
    
}  
#cloudwatch log group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
    retention_in_days = 1
}
