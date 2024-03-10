# Lambda IAM policy for CloudWatch Logs
resource "aws_iam_policy" "lambda_logging" {
  name        = "ChatbotLambdaLoggingPolicy"
  description = "IAM policy for logging from a Lambda to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

# Lambda IAM role for S3 access
resource "aws_iam_policy" "lambda_logger_s3_access" {
  name        = "lambda_logger_s3_access"
  description = "Allow Lambda to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:*",
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}",
        ],
        Effect = "Allow",
      },
    ],
  })
}
