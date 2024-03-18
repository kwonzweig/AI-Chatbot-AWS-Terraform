# frontend/streamlit_app.py
import os

import requests
import streamlit as st

from env import logger_endpoint, chatbot_endpoint


def log_conversation(messages):
    """
    Sends the conversation history to the logger function.
    """
    payload = {"messages": messages}
    try:
        response = requests.post(logger_endpoint, json=payload)
        if response.status_code != 200:
            st.error(f"Failed to log conversation: {response.text}")
    except Exception as e:
        st.error(f"An error occurred while logging the conversation: {e}")


def chatbot_call(prompt: str):
    # # Add the user's prompt to the session_state
    st.session_state.messages.append({"role": "user", "content": prompt})
    st.chat_message("user").write(prompt)

    # Prepare the payload with the entire conversation history
    payload = {"messages": st.session_state.messages}

    # Make the POST request to the chatbot API
    response = requests.post(chatbot_endpoint, json=payload)
    if response.status_code == 200:
        chat_response = response.json()["response"]
        msg = chat_response
    else:
        msg = f"Sorry, something went wrong with the chatbot. {response.text}"

    # Add response of Chatbot to the session_state
    st.session_state.messages.append({"role": "assistant", "content": msg})
    st.chat_message("assistant").write(msg)

    # Log the conversation after each exchange
    log_conversation(st.session_state.messages)
    return


# Set the title and caption
st.title('💬 Customer Service Chatbot API')
st.caption("🚀 A streamlit chatbot powered by OpenAI LLM + Terraform + AWS")

st.subheader("Github: https://github.com/kwonzweig/AI-Chatbot-AWS-Terraform", divider='rainbow')

# Initialize the session_state for the chat messages
if "messages" not in st.session_state:
    st.session_state["messages"] = [
        {"role": "assistant",
         "content": "Hi, I am a Customer Service Chatbot for the property management company, 'AIRent'.\n\n"
                    "How can I help you?"}
    ]

# Display the chat messages
for msg in st.session_state.messages:
    st.chat_message(msg["role"]).write(msg["content"])

# Add a section for user input
if prompt := st.chat_input():
    # # Add the user's prompt to the session_state before making the call
    chatbot_call(prompt)

# Add a section for suggested questions
else:
    st.subheader("Suggested Questions")

    # Make a clickable text so that when user clicks on them, it gets added to the chat input.
    list_faq_questions = [
        "How do I pay my rent?",
        "How do I report a maintenance issue in my apartment?",
        "How do I renew my lease?"
    ]

    for faq_question in list_faq_questions:
        if st.button(faq_question):
            prompt = faq_question

            # st.chat_message("user").write(prompt)
            chatbot_call(prompt)
