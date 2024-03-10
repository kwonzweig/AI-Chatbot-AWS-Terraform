resource "aws_api_gateway_rest_api" "chatbot_api" {
  name        = "ChatbotAPI"
  description = "API for handling chatbot requests"
}

# Chatbot Lambda
resource "aws_api_gateway_resource" "chatbot_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  parent_id   = aws_api_gateway_rest_api.chatbot_api.root_resource_id
  path_part   = "chatbot"
}

resource "aws_api_gateway_method" "chatbot_post" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.chatbot_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "chatbot_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatbot_lambda.invoke_arn
}

resource "aws_lambda_permission" "chatbot_api_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatbot_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.chatbot_api.execution_arn}/*/*/*"
}


# Logger Lambda
resource "aws_api_gateway_resource" "logger_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  parent_id   = aws_api_gateway_rest_api.chatbot_api.root_resource_id
  path_part   = "logger" # Assuming 'logger' is the endpoint for logging
}

# Logger POST method
resource "aws_api_gateway_method" "logger_post" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.logger_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "logger_lambda_integration_post" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.logger_resource.id
  http_method = aws_api_gateway_method.logger_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_logger.invoke_arn
}

# Logger GET method
resource "aws_api_gateway_method" "logger_get" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.logger_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "logger_lambda_integration_get" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.logger_resource.id
  http_method = aws_api_gateway_method.logger_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_logger.invoke_arn
}

resource "aws_lambda_permission" "logger_api_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayLogger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_logger.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.chatbot_api.execution_arn}/*/*/*"
}

# Logger GET method with filename parameter in path
resource "aws_api_gateway_resource" "logger_filename_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  parent_id   = aws_api_gateway_resource.logger_resource.id # Make sure it's a child of `logger_resource`
  path_part   = "{filename}"                                # Dynamic path part
}

resource "aws_api_gateway_method" "logger_filename_get" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.logger_filename_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "logger_filename_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.logger_filename_resource.id
  http_method = aws_api_gateway_method.logger_filename_get.http_method

  integration_http_method = "POST" # Lambda functions are invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_logger.invoke_arn
}


# Deployment
resource "aws_api_gateway_deployment" "chatbot_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.chatbot_lambda_integration,
    aws_api_gateway_integration.logger_lambda_integration_post,
    aws_api_gateway_integration.logger_lambda_integration_get,
    aws_api_gateway_integration.logger_filename_lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  stage_name  = "prod"

  triggers = {
    redeployment = sha256(jsonencode(
      aws_api_gateway_rest_api.chatbot_api.body,

      )
    )
  }
}
