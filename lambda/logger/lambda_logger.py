import json
import logging
import os
from datetime import datetime

import boto3

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize the S3 client
s3_client = boto3.client('s3')


def lambda_handler(event, context):
    http_method = event['httpMethod']

    # Bucket name from environment variable
    bucket_name = os.environ['S3_BUCKET_NAME']

    # Handle the POST and GET requests
    if http_method == 'POST':
        try:
            # Generate a unique filename based on the current timestamp
            filename = f"conversation_logs/{datetime.now().isoformat()}.json"

            # Assuming the body of the event contains the conversation data
            conversation_data = event['body'] if 'body' in event else json.dumps(event)

            # Write the conversation data to S3
            s3_client.put_object(Bucket=bucket_name, Key=filename, Body=conversation_data)

            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Successfully logged conversation to S3'})
            }
        except Exception as e:
            logger.error(f"Error in generating response from OpenAI: {e}", exc_info=True)
            return {
                'statusCode': 500,
                'body': json.dumps({'error': f'Failed to log conversation to S3 {e}'})
            }
    elif http_method == 'GET':

        # Check if there's a filename parameter in the path
        filename = event['pathParameters'].get('filename') if event['pathParameters'] else None

        if filename:
            try:
                # Get the object from S3
                response = s3_client.get_object(Bucket=bucket_name, Key=f'conversation_logs/{filename}')
                conversation_data = response['Body'].read().decode('utf-8')

                return {
                    'statusCode': 200,
                    'body': conversation_data
                }
            except s3_client.exceptions.NoSuchKey:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'error': 'File not found'})
                }
            except Exception as e:
                logger.error(f"Error in fetching conversation log from S3: {e}", exc_info=True)
                return {
                    'statusCode': 500,
                    'body': json.dumps({'error': f'Failed to fetch conversation log from S3 {e}'})
                }
        else:
            # List all the conversation log files
            try:
                # List all the objects in the bucket
                response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix='conversation_logs/')

                # Extract the filenames from the response
                log_files = [obj['Key'] for obj in response['Contents']]

                return {
                    'statusCode': 200,
                    'body': json.dumps(log_files)
                }
            except Exception as e:
                logger.error(f"Error in fetching conversation logs from S3: {e}", exc_info=True)
                return {
                    'statusCode': 500,
                    'body': json.dumps({'error': f'Failed to fetch conversation logs from S3 {e}'})
                }
    else:
        return {
            'statusCode': 405,
            'body': json.dumps({'error': f'Unsupported method: {http_method}'})
        }
