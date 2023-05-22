# Purpose: Create SQS queue for S3 event notification
resource "aws_sqs_queue" "queue" {
    name="${var.app_env}-event-notification-queue"
    policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Id": "s3-event-notification-queue",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "SQS:SendMessage",
                "Resource": "*",
                "Condition": {
                    "ArnEquals": {
                        "aws:SourceArn": "*"
                    }
                }
            }
        ]
    }


POLICY
}


