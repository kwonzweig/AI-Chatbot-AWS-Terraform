import json
import logging
import os

from openai import OpenAI

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load OpenAI API key from environment variable
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))


def chatbot_response(messages):
    try:
        # Your existing logic for prepending the system message
        system_message = {
            "role": "system",
            "content": (
                "You are a knowledgeable customer service assistant "
                "for a property management company called 'AIRent'. "
                "Provide helpful and accurate information about rental agreements, "
                "maintenance issues, and payment questions."
            )
        }

        # Ensure the system message is always at the beginning of the conversation
        conversation_history = [system_message] + messages

        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=conversation_history
        )

        # Extracting the text from the response
        return response.choices[0].message.content
    except Exception as e:
        logger.error(f"Error in generating response from OpenAI: e", exc_info=True)
        return f"Error in generating response from OpenAI: {e}"


def lambda_handler(event, context):
    try:
        # Parse the incoming event to get the request body
        body = json.loads(event['body'])

        # Request body can be a string or a dictionary
        if 'body' in body:
            actual_body = json.loads(body['body'])
        else:
            actual_body = body

        # Extract the messages from the request body
        messages_dicts = [{"role": msg["role"], "content": msg["content"]} for msg in actual_body["messages"]]

        # Call your chatbot response function
        response_text = chatbot_response(messages_dicts)

        logger.info("Successfully processed the request.")

        # Return the appropriate response structure
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'response': response_text})
        }

    except Exception as e:
        logger.error(f"Error in generating response from OpenAI: {e}", exc_info=True)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': f"Error processing your request {e}"})
        }
