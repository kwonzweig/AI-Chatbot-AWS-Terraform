variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "lambda_chatbot_file" {
  description = "The path to the chatbot Lambda function ZIP file."
  type        = string
  default     = "../lambda/chatbot/chatbot.zip" # Adjust this path as necessary
}

variable "lambda_logger_file" {
  description = "The path to the logger Lambda function ZIP file."
  type        = string
  default     = "../lambda/logger/logger.zip" # Adjust this path as necessary
}

#variable "lambda_logger_post_file" {
#  description = "The path to the logger Lambda function ZIP file."
#  type        = string
#  default     = "../lambda/logger/logger_post.zip" # Adjust this path as necessary
#}
#
#variable "lambda_logger_get_file" {
#  description = "The path to the logger Lambda function ZIP file."
#  type        = string
#  default     = "../lambda/logger/logger_get.zip" # Adjust this path as necessary
#
#}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing logs."
  type        = string
  default     = "demo-chatbot-log"
}

variable "openai_api_key" {
  description = "The API key for OpenAI."
  type        = string
}

variable "aws_key_pair_name" {
  description = "The name of the AWS key pair to use for SSH access."
  type        = string
}

variable "private_key_path" {
  description = "The path to the private key downloaded from AWS for SSH access."
  type        = string
}

variable "ec2_user" {
  default = "ec2-user"
}