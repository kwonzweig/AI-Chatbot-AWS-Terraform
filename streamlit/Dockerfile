# Use the official Python image as a parent image
FROM python:3.11-slim

# Set the environment variable to the API endpoint
ARG CHATBOT_API_ENDPOINT
ENV CHATBOT_API_ENDPOINT=${CHATBOT_API_ENDPOINT}

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install any dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the content of the local src directory to the working directory
COPY . .

# Specify the command to run on container start
CMD ["streamlit", "run", "chat_interface.py", "--server.port=8501"]
