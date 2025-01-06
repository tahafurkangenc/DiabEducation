from pydantic import BaseModel
from typing import Optional

class UserIn(BaseModel):
    username: str
    password: str

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
