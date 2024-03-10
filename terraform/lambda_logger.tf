resource "aws_iam_role" "lambda_logger_role" {
  name = "loggerLambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
        Sid    = "",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "logger_lambda_basic_execution" {
  role       = aws_iam_role.lambda_logger_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach the CloudWatch Logs policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_logger_cw_attachment" {
  role       = aws_iam_role.lambda_logger_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_iam_role_policy_attachment" "lambda_logger_s3_attachment" {
  role       = aws_iam_role.lambda_logger_role.name
  policy_arn = aws_iam_policy.lambda_logger_s3_access.arn
}


resource "aws_lambda_function" "lambda_logger" {
  function_name    = "LoggerFunction"
  handler          = "lambda_logger.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_logger_role.arn
  filename         = var.lambda_logger_file
  source_code_hash = filebase64sha256(var.lambda_logger_file)

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }
}
