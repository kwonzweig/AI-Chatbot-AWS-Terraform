# Access the API endpoint from environment variable
import os

api_gateway_endpoint = os.getenv('CHATBOT_API_ENDPOINT')

chatbot_endpoint = f"{api_gateway_endpoint}/chatbot"
logger_endpoint = f"{api_gateway_endpoint}/logger"
