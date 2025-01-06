import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/module_progress.dart';
import '../models/category_progress.dart';
import '../models/health_parameters.dart';
import '../models/exercise_plan.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Kullanıcı Girişi
  static Future<bool> auth_login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['access_token'];
      await _storage.write(key: 'access_token', value: token);
      return true;
    } else {
      return false;
    }
  }

/*  static Future<bool> auth_register(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true; // Kayıt başarılı
    } else {
      return false; // Kayıt başarısız
    }
  }*/

  static Future<bool> auth_register(String username, String password //, double latitude, double longitude
      ) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password
        //'location': {'latitude': latitude, 'longitude': longitude},
      }),
    );

    return response.statusCode == 200;
  }


  /// Token'ı Alma
  static Future<String?> auth_getToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// Çıkış Yapma (Token Silme)
  static Future<void> auth_logout() async {
    await _storage.delete(key: 'access_token');
  }

  /// Modül İlerlemesini Güncelleme
  static Future<bool> updateProgress(
      String category, String moduleName, bool completed, int completionPercentage, String topic) async {
    final url = Uri.parse('$baseUrl/education/progress/update?category=$category');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'module_name': moduleName,
        'completed': completed,
        'completion_percentage': completionPercentage,
        'topic': topic,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Güncelleme hatası: ${response.body}');
      return false;
    }
  }

  /// Tamamlanan Modülleri Alma
  static Future<List<dynamic>> getCompletedModules() async {
    final url = Uri.parse('$baseUrl/education/progress/completed');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['completed_categories'];
    } else {
      throw Exception('Tamamlanan modüller alınamadı: ${response.body}');
    }

  }

  /// Modül İlerlemesini Silme
  static Future<bool> deleteProgress(String category, String moduleName) async {
    final url = Uri.parse(
        '$baseUrl/education/progress/delete?category=$category&module_name=$moduleName');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Silme hatası: ${response.body}');
      return false;
    }
  }



  /// Tüm İlerlemenin Alınması
  static Future<List<CategoryProgress>> getAllProgress() async {
    final url = Uri.parse('$baseUrl/education/progress');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categoriesJson = data['categories'] as List;

      List<CategoryProgress> categories = categoriesJson
          .map((categoryJson) => CategoryProgress.fromJson(categoryJson))
          .toList();

      return categories;
    } else {
      throw Exception('İlerleme bilgileri alınamadı: ${response.body}');
    }
  }

  /// Belirli bir kategorinin ilerlemesini alır
  static Future<CategoryProgress> getCategoryProgress(String categoryName) async {
    final url = Uri.parse('$baseUrl/education/progress/$categoryName');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CategoryProgress.fromJson(data);
    } else {
      throw Exception('Kategori bilgileri alınamadı: ${response.body}');
    }
  }


  static Future<ExercisePlan> generateExercisePlan(
      HealthParameters params) async {
    final url = Uri.parse('$baseUrl/generate_exercise_plan/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(params.toJson()),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return ExercisePlan.fromJson(jsonResponse);
    } else {
      throw Exception(
          'API hatası: ${response.statusCode}, mesaj: ${response.body}');
    }
  }

  /// Tüm Eğitimleri Getirme
  static Future<List<dynamic>> getAllEducations() async {
    final url = Uri.parse('$baseUrl/education/available');
    final token = await auth_getToken(); // Tokeni alıyoruz

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Tokeni Authorization header ile gönderiyoruz
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['available_educations']; // Doğru JSON anahtarını döndürüyoruz
    } else {
      throw Exception('Eğitimler alınamadı: ${response.body}');
    }
  }

  /// Eğitim Ekleme (Swagger UI üzerinden de eklenebilir)
  static Future<bool> addEducation(String title, String description, String category, int duration, String instructor) async {
    final url = Uri.parse('$baseUrl/education/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'category': category,
        'duration': duration,
        'instructor': instructor,
      }),
    );

    return response.statusCode == 200;
  }

  /// Kullanıcının ilerlemesine eğitim ekler
  static Future<bool> addToProgress(String moduleName) async {
    final url = Uri.parse('$baseUrl/education/progress/add');
    final token = await auth_getToken();

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapın.');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'module_name': moduleName}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Eğitim eklenemedi: ${response.body}');
    }
  }


  static Future<String?> fetchUsername() async {
    final token = await auth_getToken();
    final url = Uri.parse('$baseUrl/education/user');
    if (token == null) return null;

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['username'];
    } else {
      throw Exception('Failed to load user info');
    }
  }


}
