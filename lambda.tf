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
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource": "${aws_s3_bucket.bucket.arn}"
     },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "lambda:InvokeFunction"
        ],
        "Resource": "${aws_sqs_queue.queue.arn}"
      },
      


      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams",
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ],
        "Resource": "${aws_dynamodb_table.dynamodb_table.arn}"
      },
      ##permissions of amazon RDS
      { 
        "Effect": "Allow",
        "Action": [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ],
        "Resource": "*"
      }
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
    handler       = "index.lambda_handler"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime       = "python3.8"
    #tempo limite de execução da função lambda
    timeout       = 20

     vpc_config {
      subnet_ids         = [module.vpc.private_subnets[0]]
      security_group_ids = [aws_security_group.lambda_sg.id]
  }
    depends_on = [aws_vpc_endpoint.dynamodb_endpoint]

    # environment {
    #   variables = {
    #     S3_BUCKET = aws_s3_bucket.bucket.id
    #     SQS_QUEUE = aws_sqs_queue.queue.id
    #     DB_HOST = aws_db_instance.database_lambda.endpoint
    #     DB_USER = aws_db_instance.database_lambda.username
    #     DB_PASS = aws_db_instance.database_lambda.password
    #     DB_NAME = aws_db_instance.database_lambda.db_name
    #   }
    
  #}

    #environment variables

}