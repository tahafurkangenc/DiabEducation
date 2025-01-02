from fastapi import APIRouter, HTTPException
from auth import create_access_token, verify_password, get_password_hash
from database import users_collection
from models import UserIn, UserLogin

auth_router = APIRouter()

@auth_router.post("/register")
async def register_user(user: UserIn):
    # Username kontrolü
    if users_collection.find_one({"username": user.username}):
        raise HTTPException(status_code=400, detail="Username already exists")
    
    # Parola hash'lenip kullanıcı kaydediliyor
    hashed_password = get_password_hash(user.password)
    users_collection.insert_one({"username": user.username, "password": hashed_password})
    
    return {"message": "User registered successfully"}

@auth_router.post("/login")
async def login_user(user: UserLogin):
    print(user)
    existing_user = users_collection.find_one({"username": user.username})
    print("USER EXIST:\n "+str(existing_user))
    if not existing_user or not verify_password(user.password, existing_user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token = create_access_token(data={"sub": user.username})
    return {"access_token": access_token, "token_type": "bearer"}
