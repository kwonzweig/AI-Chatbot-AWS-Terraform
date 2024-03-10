resource "aws_security_group" "streamlit_sg" {
  name        = "streamlit_app_sg"
  description = "Security group for Streamlit application"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "StreamlitAppSecurityGroup"
  }
}

resource "aws_instance" "app_instance" {
  ami                    = "ami-07761f3ae34c4478d" # Example AMI, replace with the latest or your desired AMI
  instance_type          = "t2.micro"
  key_name               = var.aws_key_pair_name
  vpc_security_group_ids = [aws_security_group.streamlit_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "CHATBOT_API_ENDPOINT=${aws_api_gateway_deployment.chatbot_api_deployment.invoke_url}" >> /etc/environment
              sudo yum update -y
              sudo yum install git -y
              sudo amazon-linux-extras install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF

  provisioner "remote-exec" {
    inline = [
      "sudo git clone https://github.com/kwonzweig/chatbot-api-aws-terraform.git /home/ec2-user/chatbot-api-aws-terraform",
      "cd /home/ec2-user/chatbot-api-aws-terraform/streamlit && sudo docker build -t streamlit-app . && sudo docker run -d -p 80:8501 --restart=always -e CHATBOT_API_ENDPOINT=$(grep CHATBOT_API_ENDPOINT /etc/environment | cut -d'=' -f2) streamlit-app"
    ]

    connection {
      type        = "ssh"
      user        = var.ec2_user
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "StreamlitAppDockerInstance"
  }
}
