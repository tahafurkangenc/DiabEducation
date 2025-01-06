from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["education_app"]

users_collection = db["users"]
progress_collection = db["progress"]
education_collection= db["courses"]