from flask import Flask, render_template, request , session
import gemini
import ollama_l

app = Flask(__name__)
ollama_chat_history=[]
@app.route('/', methods=['GET', 'POST'])

def index():
    response = None
    prompt = ''
    selected_model = 'ollama'  # Varsayılan model

    if request.method == 'POST':
        prompt = request.form['prompt']
        selected_model = request.form['model']
        
        ollama_chat_history.append({'role': 'user', 'content': prompt})
        # Yeni prompt'u sohbet geçmişine ekle
        if selected_model == 'ollama':
            response = ollama_l.ask_ollama_chat(ollama_chat_history)
            ollama_chat_history.append({'role': 'assistant', 'content': response})
            print("appended chat history : "+str(session['chat_history']))
        elif selected_model == 'gemini':
            response = gemini.ask_gemini_chat(prompt)
        else:
            response = "Geçersiz model seçildi."

    return render_template('index.html', response=response, prompt=prompt, selected_model=selected_model)

if __name__ == '__main__':
    app.run(debug=True)
