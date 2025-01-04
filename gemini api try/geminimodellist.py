import pprint
import google.generativeai as genai

genai.configure(api_key="AIzaSyCGpBhLQiQ7qskZNmgOjkh_NsR8jzql-lE")

for model_info in genai.list_tuned_models():
    print(model_info.name)