import google.generativeai as genai
#from load_creds import load_creds

#creds = load_creds()

#genai.configure(credentials=creds)
with open("gemini_key.txt") as keyfile:
    key = keyfile.read()

genai.configure(api_key=key)
model2 = genai.GenerativeModel(model_name="gemini-1.5-flash-latest")
model = genai.GenerativeModel(model_name="tunedModels/diabetesqamodel-y6mrmbik22oe")
"""
for model_info in genai.list_tuned_models():
    print(model_info.name)

generation_config = {
  "temperature": 1,
  "top_p": 0.95,
  "top_k": 64,
  "max_output_tokens": 8192,
  "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
  model_name="tunedModels/aidcaregeminidiabetestrainigtry1-t1xvpnr",
  generation_config=generation_config,
)

#model= genai.GenerativeModel(model_name="tunedModels/aidcaregeminidiabetestrainigtry1-t1xvpnr")
"""
chat = model.start_chat(
    history=[
        {"role": "user", "parts": "Merhaba. Sen diyabet hastaları için yapılan bir uygulama için chatbot görevi görüyorsun ve senin adın CAREBOT."},
        {"role": "model", "parts": "CAREBOT göreve hazır"},
    ]
)
chat2 = model2.start_chat(
    history=[
        {"role": "user", "parts": "Merhaba. Sen diyabet hastaları için yapılan bir uygulama için chatbot görevi görüyorsun ve senin adın CAREBOT."},
        {"role": "model", "parts": "CAREBOT göreve hazır"},
    ]
)

def transform_format(data):
    transformed_data = []
    for item in data:
        # Her bir öğeyi yeni formata çevir
        transformed_item = {
            "role": item['role'],
            "parts": item['content']
        }
        transformed_data.append(transformed_item)
    return transformed_data


def ask_gemini(prompt: str):
    response = model.generate_content(prompt)
    return response.text
def ask_gemini_chat(promt: str):
    response=chat.send_message(promt)
    response2=chat2.send_message(promt)
    return response2.text +" <--NOT TUNED ANSWER  TUNED ANSWER-->"+response.text
def ask_trained_gemini_chat_with_memory (chat_history: list):
    print(str(chat_history))
    prompt_JSON=chat_history[len(chat_history)-1]
    geminis_chat=model.start_chat(history=(transform_format(chat_history)).pop())
    #geminis_chat=model.start_chat(history=(chat_history))
    response=geminis_chat.send_message(str(prompt_JSON["content"]))
    return response.text