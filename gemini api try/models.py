from pydantic import BaseModel
from typing import Optional

class UserIn(BaseModel):
    username: str
    password: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None

class UserLogin(BaseModel):
    username: str
    password: str

# Belirli bir modülün ilerleme durumunu güncellemek için kullanılacak model
class ModuleProgressUpdate(BaseModel):
    module_name: str
    completed: bool
    completion_percentage: int
    topic: str

# Kullanıcının tüm modüllerini dönerken kullanabileceğimiz bir model
class ModuleProgress(BaseModel):
    name: str
    completion_percentage: int
    completed: bool

class Education(BaseModel):
    title: str
    description: str
    category: str
    duration: int  # Dakika cinsinden
    instructor:str

class ModuleAddRequest(BaseModel):
    module_name: str