# DiabEducation
DiabEducation, diyabet hakkında farkındalık yaratılması için geliştirilmiş bir eğitim uygulamasıdır. DiabEducation, kullanıcılarına çeşitli videolar ile diyabet hastalığı hakkında bilgi vermeyi amaçlamaktadır. Uygulama, aynı zamanda kullanıcıları için, GEMINI AI'dan yardım alarak, kişiselleştirilmiş egzersiz planları da oluşturabilmektedir.

## Ekran Görüntüleri

|                          |                          |
|:------------------------:|:------------------------:|
| Giriş Ekranı                |   Eğitim Sınıfları           |
| <img src="https://github.com/user-attachments/assets/bd3c68bf-17ba-44f6-bd71-3ae1ef534cd4" width="300"/> | <img src="https://github.com/user-attachments/assets/18465b42-0454-445a-9ba8-18b51dce6952" width="300"/> |
| Mağaza                  |       Kaydedilen İlerleme                   |
| <img src="https://github.com/user-attachments/assets/c845e87d-e706-4d84-a18c-49f81070d580" width="300"/> | <img src="https://github.com/user-attachments/assets/d2e1ffa7-9fbf-4169-abf6-86815bb5755d" width="300"/>                         |

Drive Video Link : https://drive.google.com/file/d/1dZ8evjwSaRmTx-DamZfSUlfMZ9iFCbfV/view?usp=sharing 

## Kurulum Detayları
### Kurulum Öncesi Gereksinimler
- MongoDB + MongoDB Compass (Tavsiye edilir) (Yerel veritabanı İçin)
- Python (FastAPI ve AI tarafının derlenebilmesi için)
- Flutter (Mobil uygulamanın derlenebilmesi için)
- Android Studio (Telefon emülatörü için)

### Flutter Uygulamasının Kurulumu
#### Adım #1: GitHub Repository'sinin Klonlanması
Aşağıdaki komutu, istediğiniz klasörün içinde çalıştırınız:
- git clone https://github.com/tahafurkangenc/DiabEducation.git

#### Adım #2: Dependency'lerin Kurulması
Aşağıdaki komutu, proje klasörünün içerisinde çalıştırınız:
- flutter pub get

#### Adım #3: Projenin Build'inin Alınması
Aşağıdaki komutları, proje klasörünün içerisinde çalıştırıız:
- Android için: flutter build apk
- iOS için: flutter build ios

#### Adım #4: Projenin Çalıştırılması
Aşağıdaki komutu, proje klasörünün içerisinde çalıştırınız:
- flutter run

### FastAPI Kurulumu
#### Adım #1: Sanal Environment (venv) Oluşturma ve Aktive Etme
Aşağıdaki komutu "gemini api try" klasörünün içerisinde çalıştırınız:
- python -m venv .venv

Ardından şu komutu çalıştırınız.
- Linux için: source .venv/bin/activate
- Windows için: .venv\Scripts\activate

#### Adım #2: Gerekli Paketlerin Kurulması
Aşağıdaki komutu "gemini api try" klasörü içerisinde çalıştırınız.
- pip install -r requirements.txt

#### Adım #3: FastAPI Çalıştırılması
Aşağıdaki komutu, "gemini api try" klasörü içerisinde çalıştırınız:
- uvicorn fastapimain:app --reload

#### Adım #4: MongoDB Kurulumu
Bilgisayarınzda MongoDB kurulu ise "mongodb://localhost:27017" (tırnaklar olmadan) adresine bağlanın. Ardından "education_app" adında yeni bir veritabanı oluşturun.

## Branch Pull Request Açıklamaları
### Merge #1
- **Yazar:** tahafurkangenc (Taha Furkan Genç)
- **Commit:** add Gemini and Ollama mıodels https://github.com/tahafurkangenc/DiabEducation/pull/1
- **Merge Edilen Branch:** development-ai
- **Açıklama:**
    - Ollama ve Gemini modellerininin ilk dosyaları yüklendi. Egzersiz önerisi için endpoint yazıldı.

### Merge #2
- **Yazar:** GkslOkn (Göksel Okandan)
- **Commit:** Add api-service https://github.com/tahafurkangenc/DiabEducation/pull/2
- **Merge Edilen Branch:** development-restful
- **Açıklama:**
    - Mobil projenin sunucuya bağlanması için kullanılacak API servisi dosyası yazıldı.

### Merge #3
- **Yazar:** GkslOkn (Göksel Okandan)
- **Commit:** Development Merge #1 https://github.com/tahafurkangenc/DiabEducation/pull/3
- **Merge Edilen Branch:** development
- **Açıklama:**
    - İlk development main arası merge gerçekleştirilemedi. Pull Request proje kuralları gereği kapatıldı.

### Merge #4
- **Yazar:** ozgurozkan01 (Özgür Özkan)
- **Commit:** add authorization https://github.com/tahafurkangenc/DiabEducation/pull/4
- **Merge Edilen Branch:** development-authorization
- **Açıklama:**
    - Kullanıcı kayıt ve girişleri için JWT kullanarak Authorization sağlandı.

### Merge #5
- **Yazar:** AlperenKaracan (Alperen Karacan)
- **Commit:** Development UI Pull Request https://github.com/tahafurkangenc/DiabEducation/pull/5
- **Merge Edilen Branch:** development-ui
- **Açıklama:**
    - Uygulamanın ilk arayüz sayfaları eklendi.

### Merge #6
- **Yazar:** tahafurkangenc (Taha Furkan Genç)
- **Commit :** all ai files https://github.com/tahafurkangenc/DiabEducation/pull/6
- **Merge Edilen Branch:** development-ai
- **Açıklama:**
    - Fine-Tune’lanmış  gemini AI modelinin erişiminin sağlanması için dosyalar ve methodları eklendi.

### Merge #7
- **Yazar:** ozgurozkan01 (Özgür Özkan)
- **Commit:** add new authorization https://github.com/tahafurkangenc/DiabEducation/pull/7
- **Merge Edilen Branch:** development-authorization
- **Açıklama:**
    - Kullanıcı kayıt ve girişleri için JWT kullanarak Auth dosyaları düzenlendi

### Merge #8
- **Yazar:** ozgurozkan01 (Özgür Özkan)
- **Commit:** add new authorization https://github.com/tahafurkangenc/DiabEducation/pull/8
- **Merge Edilen Branch:** development-authorization
- **Açıklama:**
    - Kullanıcı kayıt ve girişleri için JWT kullanarak Auth dosyaları düzenlendi. Önceki Pull Request'in kazara main'e atılması sonrasında development'a Pull Request açılmıştır.

### Merge #9
- **Yazar:** tahafurkangenc (Taha Furkan Genç)
- **Commit:** Development RESTful Finished https://github.com/tahafurkangenc/DiabEducation/pull/9
- **Merge Edilen Branch:** development-restful
- **Açıklama:**
    - RESTful API için modeller ve endpointler yazıldı.

### Merge #10
- **Yazar:** GkslOkn (Göksel Okandan)
- **Commit:** Development broadcast receiver finished https://github.com/tahafurkangenc/DiabEducation/pull/10
- **Merge Edilen Branch:** development-broadcast-receiver
- **Açıklama:**
    - BroadCast Receiver özelliği eklemek için ConnectivityListener kullanıldı.

### Merge #11
- **Yazar:** AlperenKaracan (Alperen Karacan)
- **Commit:** Development UI https://github.com/tahafurkangenc/DiabEducation/pull/11
- **Merge Edilen Branch:** development-ui
- **Açıklama:**
    - Uygulamanın ekranlar kısmında, işlevsellikte çeşitli güncellemeler yapıldı.

### Merge #12
- **Yazar:** AlperenKaracan (Alperen Karacan)
- **Commit:** Finished Storage Files https://github.com/tahafurkangenc/DiabEducation/pull/12
- **Merge Edilen Branch:** development-storage
- **Açıklama:**
    - Veri tabanı şemaları oluşturuldu ve bağlantı sağlandı.

### Merge #13
- **Yazar:** LastViolin44 (Mehmet Ali Kır)
- **Commit:** Added Location Sensor Files (Finished) https://github.com/tahafurkangenc/DiabEducation/pull/13
- **Merge Edilen Branch:** development-sensor
- **Açıklama:**
    - Location sensörünün rahat kulllanılması için location_service.dart yazıldı ve projeye entegre edildi.

### Merge #14
- **Yazar:** LastViolin44 (Mehmet Ali Kır)
- **Commit:** Added finished connection files. https://github.com/tahafurkangenc/DiabEducation/pull/14
- **Merge Edilen Branch:** development-connectivity
- **Açıklama:**
    - api_services.dart API bağlantı dosyası güncellendi.

### Merge #15
- **Yazar:** tahafurkangenc (Taha Furkan Genç)
- **Commit:** lst files https://github.com/tahafurkangenc/DiabEducation/pull/15
- **Merge Edilen Branch:** development-ai
- **Açıklama:**
    - Gemini AI için client_secret.json ve gemini_key.txt eklendi.

### Merge #16
- **Yazar:** tahafurkangenc (Taha Furkan Genç)
- **Commit:** sql files https://github.com/tahafurkangenc/DiabEducation/pull/16
- **Merge Edilen Branch:** development-local-db
- **Açıklama:**
    - SQLite kullanımını kolaylaştırmak için database_helper.dart dosyası oluşturuldu.

### Merge #17
- **Yazar:** ozgurozkan01 (Özgür Özkan)
- **Commit:** add background service https://github.com/tahafurkangenc/DiabEducation/pull/17
- **Merge Edilen Branch:** development-bg-process
- **Açıklama:**
    - Arkaplanda bildirim işlerini yürütmesi için background_services.dart oluşturuldu. "main" branchine Pull Request atıldığı için iptal edilmiştir.

### Merge #18
- **Yazar:** ozgurozkan01 (Özgür Özkan)
- **Commit:** add background service https://github.com/tahafurkangenc/DiabEducation/pull/18
- **Merge Edilen Branch:** development-bg-process
- **Açıklama:**
    - Arkaplanda bildirim işlerini yürütmesi için background_services.dart oluşturuldu.

### Merge #19
- **Yazar:** GkslOkn (Göksel Okandan)
- **Commit:** Development Merge Final https://github.com/tahafurkangenc/DiabEducation/pull/19
- **Merge Edilen Branch:** development
- **Açıklama:**
    - Proje tamamlandı. "main" branchine Pull Request atılarak proje "main" branchine aktarıldı.

## Emeği Geçenler
- Taha Furkan GENÇ --- 210201077
- Özgür ÖZKAN --- 230201121
- Alperen KARACAN --- 210201096
- Mehmet Ali KIR --- 210201033
- Göksel OKANDAN --- 210201058
