import ollama
'''
response = ollama.chat(model='llama3.1:8b', messages=[
  {
    'role': 'user',
    'content': 'Why is the sky blue?',
  },
])
print(response['message']['content'])
'''
#from transformers import AutoModel
#tuned_model = AutoModel.from_pretrained("abdelhakimDZ/llama-3-8b-Instruct-bnb-4bit-medical-diabetes")

def ask_ollama(promt:str):
    response=ollama.chat(model='llama3.1:8b', messages=[
  {
    'role': 'user',
    'content': promt,
  }
  ])
    return response['message']['content']

def ask_ollama_chat(chat_history: list):
    print("ask_ollama_chat chat_history:list :")
    print(chat_history)
    response = ollama.chat(model='llama3.1:8b', messages=chat_history)
    print ("response : "+str(response))
    return response['message']['content']