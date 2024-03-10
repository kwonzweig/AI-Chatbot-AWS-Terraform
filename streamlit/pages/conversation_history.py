import os

import requests
import streamlit as st

from env import logger_endpoint

# Set the title and caption
st.title("📝 Conversation History (S3)")
st.caption("A log of the conversation history between the user and the chatbot.")


def fetch_logs() -> list:
    response = requests.get(logger_endpoint)
    if response.status_code == 200:
        logs = response.json()
        return logs
    else:
        st.error("Failed to fetch logs")
        return []


# Fetch the log files from the S3 bucket
log_files = fetch_logs()

# Let the user select a log file
selected_file = st.selectbox("Select a log file", log_files)

# If a file is selected, display the chat messages history
if selected_file:

    # Path to the log file
    log_file_endpoint = f"{logger_endpoint}/{selected_file.split('/')[-1]}"

    # Retrieve the chat messages from the selected log file
    response = requests.get(log_file_endpoint)

    if response.status_code == 200:
        log_content = response.json()

        # Display the chat messages
        for msg in log_content["messages"]:
            st.chat_message(msg["role"]).write(msg["content"])

    else:
        st.error(f"Failed to fetch chat messages {response.text}")
