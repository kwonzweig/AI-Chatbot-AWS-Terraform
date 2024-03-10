terraform {
  backend "remote" {
    organization = "demo-chatbot-api-org"

    workspaces {
      name = "demo-chatbot-api-workspace"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Include your S3 bucket for Chatbot conversation logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "Chatbot Conversation Logs"
  }

  # Forces deletion of all objects within the bucket so that the bucket can be destroyed
  force_destroy = true
}

