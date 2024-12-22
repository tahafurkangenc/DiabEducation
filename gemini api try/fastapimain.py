from fastapi import FastAPI, HTTPException#, File, UploadFile
from routers.auth_router import auth_router
from routers.education_router import education_router
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict
#import multipart
#import pytesseract
#from PIL import Image
#import re
#import easyocr
#import os
import json
import gemini
import ollama_l

app = FastAPI()

app.include_router(auth_router, prefix="/auth")
app.include_router(education_router, prefix="/education")

# CORS ayarları
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Güvenlik için spesifik origin'ler ekleyin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Ortak sohbet geçmişi
carebot_chat_history = []

# Tesseract'ın yolunu ayarlama (Windows için gerekliyse)
#pytesseract.pytesseract.tesseract_cmd = r"C:\\Program Files\\Tesseract-OCR\\tesseract.exe"


# Request modeli tanımla
class PromptRequest(BaseModel):
    prompt: str
    model: str

# Sohbet geçmişi için model
class ChatHistory(BaseModel):
    role: str
    content: str

# Response modeli tanımla
class ResponseModel(BaseModel):
    response: str
    chat_history: List[ChatHistory]

@app.post("/chat", response_model=ResponseModel)
async def chat_endpoint(request: PromptRequest):
    prompt = request.prompt
    selected_model = request.model

    if not prompt:
        raise HTTPException(status_code=400, detail="Prompt cannot be empty.")

    if selected_model not in ["ollama", "gemini"]:
        raise HTTPException(status_code=400, detail="Invalid model selected.")

    response = None
    # Kullanıcı prompt'u sohbet geçmişine ekleniyor
    carebot_chat_history.append({'role': 'user', 'content': prompt})

    if selected_model == "ollama":
        response = ollama_l.ask_ollama_chat(carebot_chat_history)
    elif selected_model == "gemini":
        response = gemini.ask_trained_gemini_chat_with_memory(carebot_chat_history)

    # Modelin yanıtı sohbet geçmişine ekleniyor
    carebot_chat_history.append({'role': 'assistant', 'content': response})

    return {
        "response": response,
        "chat_history": carebot_chat_history
    }
"""
# İlaç isimlerini ve detaylarını tanıma fonksiyonu
def recognize_medicine_details(image_path):
    reader = easyocr.Reader(['en'])  # EasyOCR okuyucusunu yükleme
    result = reader.readtext(image_path, detail=0)  # Detaysız metin çıktısı al

    # Çıktıyı birleştir
    extracted_text = ' '.join(result)
    print("Extracted Text:", extracted_text)

    # İlaç isimleri veri tabanı
    medicine_database = ["Paracetamol", "Ibuprofen", "Aspirin", "Amoxicillin", "Metformin", "Silverdin", "Nexium", "Levokast"]
    
    detected_medicine = None
    for medicine in medicine_database:
        if medicine.lower() in extracted_text.lower():
            detected_medicine = medicine
            break

    # mg bilgisini alma
    mg_match = re.search(r'(\d+)\s?mg', extracted_text, re.IGNORECASE)
    mg_info = mg_match.group(0) if mg_match else "mg info not found"

    # Tablet sayısını alma
    tablet_match = re.search(r'(\d+)\s?tablets?', extracted_text, re.IGNORECASE)
    tablet_info = tablet_match.group(0) if tablet_match else "tablet info not found"

    return {
        "medicine_name": detected_medicine,
        "mg_info": mg_info,
        "tablet_info": tablet_info
    }

@app.post("/medicinerecognize")
async def medicinerecognize_endpoint(image: UploadFile = File(...)):
    try:
        # Geçici dosya yolu oluşturma
        temp_image_path = "temp_image.jpg"
        with open(temp_image_path, "wb") as buffer:
            buffer.write(await image.read())

        # İlaç bilgilerini çıkarma
        details = recognize_medicine_details(temp_image_path)
        
        # Geçici dosyayı silme
        os.remove(temp_image_path)

        return details

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")
"""

# Giriş parametrelerinin modeli
class HealthParameters(BaseModel):
    gender: str  # "male", "female", "other"
    age: int
    weight: float
    height: float
    existing_conditions: list[str]  # Ör: ["diabetes", "hypertension"]
    calories_burned: float
    injury_status: str  # "none", "minor", "severe"
    blood_sugar_status: str  # "normal", "low", "high"
    tissue_damage: str  # "none", "minor", "major"


@app.post("/generate_exercise_plan/")
async def generate_exercise_plan(params: HealthParameters):
    # Prompt oluşturma
    prompt = f"""
    Based on the following health parameters:
    Gender: {params.gender}
    Age: {params.age}
    Weight: {params.weight}
    Height: {params.height}
    Existing Conditions: {params.existing_conditions}
    Calories Burned Today: {params.calories_burned}
    Injury Status: {params.injury_status}
    Blood Sugar Status: {params.blood_sugar_status}
    Tissue Damage: {params.tissue_damage}
    
    Generate a detailed exercise plan in JSON format using this schema:
    {{
        "exercise_plan": [
            {{
                "day": int,
                "exercise_name": str,
                "exercise_type": str,
                "duration_minutes": int,
                "intensity": str,
                "target_muscle_groups": list[str],
                "equipment_required": list[str],
                "calories_burned_estimate": float,
                "repetitions": int,
                "sets": int,
                "notes": str
            }}
        ]
    }}
    """
    try:
        # Gemini'den yanıt al
        response = gemini.ask_gemini(prompt)
        print("RESPONSE : ")
        print(response)
        try:
         #data = json.loads(response.replace("```json", "").replace("```", "").replace("'", '"').strip())
         data=response.replace("```json", "").replace("'", '"').replace("}{", "},{")
         print("DATA: \n"+str(data))
         data = json.loads(data)
         data = [item for item in data if item]  # Boş nesneleri çıkar
         print("Geçerli JSON formatı:")
         print(json.dumps(data, indent=4))
         return data
        except json.JSONDecodeError as e:
         print(f"JSON decode hatası: {e}")
         #responseData=response.JSON
         # Yanıt JSON formatında dönecektir
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating exercise plan: {str(e)}")