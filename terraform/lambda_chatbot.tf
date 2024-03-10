resource "aws_iam_role" "chatbot_lambda_role" {
  name = "chatbotLambdaExecutionRole"

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

resource "aws_iam_role_policy_attachment" "chatbot_lambda_basic_execution" {
  role       = aws_iam_role.chatbot_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Attach the CloudWatch Logs policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_logging_attachment" {
  role       = aws_iam_role.chatbot_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "chatbot_lambda" {
  function_name    = "ChatbotFunction"
  handler          = "lambda_chatbot.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.chatbot_lambda_role.arn
  filename         = var.lambda_chatbot_file
  source_code_hash = filebase64sha256(var.lambda_chatbot_file)

  environment {
    variables = {
      OPENAI_API_KEY = var.openai_api_key
    }
  }
}
