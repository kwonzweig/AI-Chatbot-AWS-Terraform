
# Serverless ChatBot API Deployment with Terraform on AWS

This repository contains Terraform configurations to deploy a serverless ChatBot API on AWS, utilizing various AWS services. It provides an easy and scalable way to deploy a ChatBot API, leveraging OpenAI's ChatGPT for the chatbot logic, and a Streamlit-based frontend for user interactions.

## Prerequisites

- AWS Account
- Terraform installed on your machine
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
#### 5. Run following command on deployed EC2 for streamlit frontend

```bash
cd chatbot-api-aws-terraform/streamlit
sudo docker build -t streamlit-app .
sudo docker run -d -p 80:8501 --restart=always -e CHATBOT_API_ENDPOINT=$(grep CHATBOT_API_ENDPOINT /etc/environment | cut -d'=' -f2) streamlit-app
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

## License

This project is licensed under the MIT License - see the LICENSE file for details.
