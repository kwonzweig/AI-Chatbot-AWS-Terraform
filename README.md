# AI-Chatbot-AWS-Terraform

This repository contains Terraform configurations to deploy a serverless ChatBot API on AWS, utilizing various AWS services. It provides an easy and scalable way to deploy a ChatBot API, leveraging OpenAI's ChatGPT for the chatbot logic, and a Streamlit-based frontend for user interactions.

![alt text](https://github.com/kwonzweig/AI-Chatbot-AWS-Terraform/blob/flow_diagram.png?raw=true)

## Chatbot API Demo
[Click here to access the live demo.](http://ec2-54-84-154-233.compute-1.amazonaws.com/)

Please note: The demo is deployed on an AWS EC2 instance and may be subject to downtime for maintenance or updates. 

## Features

- **Serverless Architecture**: Utilizes AWS Lambda, API Gateway, and S3 for a scalable, cost-efficient backend.
- **Terraform Automation**: Infrastructure as code (IaC) ensures repeatable, error-free deployments.
- **GitHub Actions**: Automated deployment pipeline for continuous integration and delivery.
- **Streamlit Interface**: A user-friendly frontend for interacting with the chatbot, deployed on an EC2 instance.
- **OpenAI Integration**: Leverages the power of GPT models for natural language understanding and responses.

## Prerequisites

- AWS Account
- Terraform installed on your local machine
- OpenAI API key

## Configuration

### Setting Environment Variables

#### Windows (PowerShell)

```bash
$env:AWS_ACCESS_KEY_ID="your_aws_access_key"
$env:AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
$env:TF_VAR_openai_api_key="your_openai_key"
$env:TF_VAR_private_key_path="your_key_pair_path"
$env:TF_VAR_aws_key_pair_name="your_key_pair_name"
```

#### Linux/MacOS (Bash)

```bash
export AWS_ACCESS_KEY_ID="your_aws_access_key"
export AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
export TF_VAR_openai_api_key="your_openai_key"
export TF_VAR_private_key_path="your_key_pair_path"
$env:TF_VAR_aws_key_pair_name="your_key_pair_name"
```

### Obtaining Configuration Items

- **AWS Access Key ID and Secret Access Key**: Follow the [AWS documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) on creating and managing AWS access keys.
- **OpenAI API Key**: Obtain an API key by creating an account on [OpenAI](https://openai.com/) and accessing your API keys section.
- **Private Key Path for SSH**: Generate a new key pair on AWS and save the private key to a file. The public key will be added to the EC2 instance during deployment.

## Deployment Steps

Navigate to the `terraform` directory and run the following commands:

#### 1. Initialize Terraform workspace:

```bash
terraform init
```

#### 2. Check Terraform files format (optional):

```bash
terraform fmt -check
```

#### 3. Review the Terraform plan:

```bash
terraform plan
```

#### 4. Apply the Terraform configuration to deploy your ChatBot API:

```bash
terraform apply -auto-approve -input=false
```

## Architecture Overview

- **AWS EC2**: Runs a containerized Streamlit script that serves as the frontend, allowing users to interact with the ChatBot.
- **AWS Lambda**: 
  - `chatbot` function handles user prompts using OpenAI's ChatGPT
  - `logger` function sends conversation logs to S3.
- **AWS API Gateway**: Serves as the REST API endpoint for the ChatBot API.

## Usage

After deployment, you can access the Streamlit frontend through the public IP address of the EC2 instance. This provides a user-friendly interface to interact with the deployed ChatBot.

## Cleanup

To remove the deployed resources, run the following command in the `terraform` directory:

```bash
terraform destroy
```

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues to improve the project.
