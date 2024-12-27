from fastapi import APIRouter, Depends, HTTPException, Header
from auth import decode_access_token
from database import progress_collection
from models import ModuleProgressUpdate

education_router = APIRouter()

def get_current_user(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authorization header missing")
    token = authorization.replace("Bearer ", "")
    username = decode_access_token(token)
    if not username:
        raise HTTPException(status_code=401, detail="Invalid token")
    return username

@education_router.post("/progress/update")
async def update_module_progress(
    category: str,
    data: ModuleProgressUpdate,
    user: str = Depends(get_current_user)
):
    # Veri tabanında user için ilgili kategoride modülü güncelle
    progress_collection.update_one(
        {"username": user},
        {
            "$set": {
                f"categories.{category}.{data.module_name}": {
                    "completed": data.completed,
                    "completion_percentage": data.completion_percentage,
                    "topic": data.topic  # Modülün konu başlığı
                }
            }
        },
        upsert=True
    )
    return {"message": "Module progress updated"}

@education_router.get("/progress")
async def get_all_progress(user: str = Depends(get_current_user)):
    user_progress = progress_collection.find_one({"username": user})
    if not user_progress or "categories" not in user_progress:
        return {"categories": []}

    categories_list = []
    for category_name, modules in user_progress["categories"].items():
        module_list = []
        for module_name, module_info in modules.items():
            module_list.append({
                "name": module_name,
                "completed": module_info["completed"],
                "completion_percentage": module_info["completion_percentage"],
                "topic": module_info.get("topic", "Unknown")
            })
        categories_list.append({
            "category_name": category_name,
            "modules": module_list
        })

    return {"categories": categories_list}

@education_router.get("/progress/completed")
async def get_completed_modules(user: str = Depends(get_current_user)):
    user_progress = progress_collection.find_one({"username": user})
    if not user_progress or "categories" not in user_progress:
        return {"completed_categories": []}

    completed_categories = []
    for category_name, modules in user_progress["categories"].items():
        completed_modules = [
            {
                "name": module_name,
                "topic": module_info.get("topic", "Unknown")
            }
            for module_name, module_info in modules.items()
            if module_info["completed"]
        ]
        if completed_modules:
            completed_categories.append({
                "category_name": category_name,
                "completed_modules": completed_modules
            })

    return {"completed_categories": completed_categories}
