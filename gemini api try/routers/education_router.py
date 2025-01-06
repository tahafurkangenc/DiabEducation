from fastapi import APIRouter, Depends, HTTPException, Header
from auth import decode_access_token
from database import progress_collection,education_collection
from models import ModuleProgressUpdate,Education,ModuleAddRequest

education_router = APIRouter()

def get_current_user(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Authorization header missing")
    token = authorization.replace("Bearer ", "")
    username = decode_access_token(token)
    print(username)
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
        print(categories_list)
    return {"categories": categories_list}

@education_router.get("/progress/{category_name}")
async def get_category_progress(category_name: str, user: str = Depends(get_current_user)):
    print(f"Received category name: {category_name}")  # Gelen kategoriyi logla
    user_progress = progress_collection.find_one({"username": user})
    if not user_progress or "categories" not in user_progress:
        return {"category_name": category_name, "modules": []}

    # Belirli bir kategori adıyla eşleşen veriyi döndür
    if category_name in user_progress["categories"]:
        print(user_progress["categories"])
        category_modules = user_progress["categories"][category_name]
        module_list = []
        for module_name, module_info in category_modules.items():
            module_list.append({
                "name": module_name,
                "completed": module_info["completed"],
                "completion_percentage": module_info["completion_percentage"],
                "topic": module_info.get("topic", "Unknown")
            })
        return {"category_name": category_name, "modules": module_list}

    # Eğer kategori bulunamazsa boş döndür
    return {"category_name": category_name, "modules": []}


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

@education_router.post("/progress/add")
async def add_to_progress(request: ModuleAddRequest, user: str = Depends(get_current_user)):
    module_name = request.module_name

    # Eğitim verisini education_collection'dan al
    education = education_collection.find_one({"title": module_name}, {"_id": 0})
    if not education:
        raise HTTPException(status_code=404, detail="Eğitim bulunamadı")

    # Kullanıcının mevcut ilerlemesini kontrol et
    user_progress = progress_collection.find_one({"username": user})
    
    if not user_progress:
        # Kullanıcının ilerleme kaydı yoksa yeni kayıt oluştur
        progress_collection.insert_one({
            "username": user,
            "categories": {
                education["category"]: {
                    module_name: {
                        "completed": False,
                        "completion_percentage": 0,
                        "topic": education["title"]
                    }
                }
            }
        })
    else:
        # Kullanıcının mevcut ilerlemesine modülü ekle
        progress_collection.update_one(
            {"username": user},
            {"$set": {
                f"categories.{education['category']}.{module_name}": {
                    "completed": False,
                    "completion_percentage": 0,
                    "topic": education["title"]
                }
            }},
            upsert=True
        )
    
    return {"message": f"Eğitim '{module_name}' ilerlemeye eklendi"}

@education_router.delete("/progress/delete")
async def delete_module_progress(
    category: str,
    module_name: str,
    user: str = Depends(get_current_user)
):
    # Kullanıcının ilerlemesinden modülü sil
    progress_collection.update_one(
        {"username": user},
        {"$unset": {f"categories.{category}.{module_name}": ""}}
    )

    # Kategori tamamen boşsa, kategoriyi de kaldır
    user_progress = progress_collection.find_one({"username": user})
    if (
        category in user_progress.get("categories", {})
        and not user_progress["categories"][category]
    ):
        progress_collection.update_one(
            {"username": user},
            {"$unset": {f"categories.{category}": ""}}
        )

    return {"message": f"Module '{module_name}' in category '{category}' has been deleted"}


@education_router.post("/add", response_model=dict)
async def add_education(education: Education):
    # Eğitim zaten mevcut mu kontrol et
    if education_collection.find_one({"title": education.title}):
        raise HTTPException(status_code=400, detail="Eğitim zaten mevcut.")
    
    # Eğitimi ekle
    education_collection.insert_one(education.dict())
    return {"message": "Eğitim başarıyla eklendi."}

@education_router.get("/all", response_model=dict)
async def get_all_educations():
    educations = list(education_collection.find({}, {"_id": 0}))
    return {"educations": educations}

@education_router.get("/available", response_model=dict)
async def get_available_educations(user: str = Depends(get_current_user)):
    print(user)
    # Tüm eğitimleri al
    all_educations = list(education_collection.find({}, {"_id": 0}))
    
    # Kullanıcının mevcut ilerlemesini al
    user_progress = progress_collection.find_one({"username": user})
    
    # Eğer kullanıcının hiç ilerlemesi yoksa, tüm eğitimleri döndür
    if not user_progress or "categories" not in user_progress:
        return {"available_educations": all_educations}
    
    # Kullanıcının başladığı eğitimleri topla
    started_educations = set()
    for category in user_progress["categories"].values():
        key = list(category.keys())[0]
        print(key)
        print("------")
        started_educations.add(category[key]['topic'])
    print(started_educations)
    # Başlanmamış eğitimleri filtrele
    available_educations = [
        education for education in all_educations
        if education["title"] not in started_educations
    ]

    return {"available_educations": available_educations}

@education_router.get("/user")
async def get_current_user(user: str = Depends(get_current_user)):
    return {"username": user}