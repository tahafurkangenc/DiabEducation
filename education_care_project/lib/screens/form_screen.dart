import 'package:flutter/material.dart';
import '../models/health_parameters.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import '../models/exercise_plan.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Form alanları için kontrolörler ve değişkenler oluşturun

  // Örnek olarak:
  String _selectedGender = 'male';
  int _age = 25;
  double _weight = 70.0;
  double _height = 175.0;
  List<String> _existingConditions = [];
  double _caloriesBurned = 0.0;
  String _injuryStatus = 'none';
  String _bloodSugarStatus = 'normal';
  String _tissueDamage = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sağlık Bilgileri'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
           padding: const EdgeInsets.all(16),
          child:Column(
          children: [
            // Cinsiyet seçimi
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: [
                DropdownMenuItem(child: Text('Erkek'), value: 'male'),
                DropdownMenuItem(child: Text('Kadın'), value: 'female'),
                DropdownMenuItem(child: Text('Diğer'), value: 'other'),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Cinsiyet'),
            ),

            // Yaş girişi
            TextFormField(
              initialValue: _age.toString(),
              decoration: InputDecoration(labelText: 'Yaş'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Yaş boş bırakılamaz';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _age = int.parse(value);
                });
              },
            ),

            // Kilo girişi
            TextFormField(
              initialValue: _weight.toString(),
              decoration: InputDecoration(labelText: 'Kilo (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kilo boş bırakılamaz';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _weight = double.parse(value);
                });
              },
            ),

            // Boy girişi
            TextFormField(
              initialValue: _height.toString(),
              decoration: InputDecoration(labelText: 'Boy (cm)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Boy boş bırakılamaz';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _height = double.parse(value);
                });
              },
            ),

            // Mevcut sağlık durumları
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mevcut Sağlık Durumları (virgül ile ayırın)',
              ),
              onChanged: (value) {
                setState(() {
                  _existingConditions = value.split(',').map((e) => e.trim()).toList();
                });
              },
            ),

            // Günlük yakılan kalori
            TextFormField(
              initialValue: _caloriesBurned.toString(),
              decoration: InputDecoration(labelText: 'Yakılan Kalori'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Yakılan kalori boş bırakılamaz';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _caloriesBurned = double.parse(value);
                });
              },
            ),

            // Yaralanma durumu
            DropdownButtonFormField<String>(
              value: _injuryStatus,
              items: [
                DropdownMenuItem(child: Text('Yok'), value: 'none'),
                DropdownMenuItem(child: Text('Hafif'), value: 'minor'),
                DropdownMenuItem(child: Text('Ağır'), value: 'severe'),
              ],
              onChanged: (value) {
                setState(() {
                  _injuryStatus = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Yaralanma Durumu'),
            ),

            // Kan şekeri durumu
            DropdownButtonFormField<String>(
              value: _bloodSugarStatus,
              items: [
                DropdownMenuItem(child: Text('Normal'), value: 'normal'),
                DropdownMenuItem(child: Text('Düşük'), value: 'low'),
                DropdownMenuItem(child: Text('Yüksek'), value: 'high'),
              ],
              onChanged: (value) {
                setState(() {
                  _bloodSugarStatus = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Kan Şekeri Durumu'),
            ),

            // Doku hasarı durumu
            DropdownButtonFormField<String>(
              value: _tissueDamage,
              items: [
                DropdownMenuItem(child: Text('Yok'), value: 'none'),
                DropdownMenuItem(child: Text('Hafif'), value: 'minor'),
                DropdownMenuItem(child: Text('Ağır'), value: 'major'),
              ],
              onChanged: (value) {
                setState(() {
                  _tissueDamage = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Doku Hasarı Durumu'),
            ),

            // Planı oluşturma butonu
            ElevatedButton(
              child: Text('Planı Oluştur'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Sağlık parametrelerini oluştur
                  HealthParameters params = HealthParameters(
                    gender: _selectedGender,
                    age: _age,
                    weight: _weight,
                    height: _height,
                    existingConditions: _existingConditions,
                    caloriesBurned: _caloriesBurned,
                    injuryStatus: _injuryStatus,
                    bloodSugarStatus: _bloodSugarStatus,
                    tissueDamage: _tissueDamage,
                  );

                  // API çağrısı yap
                  try {
                    ExercisePlan plan =
                    await ApiService.generateExercisePlan(params);
                    // Sonuç sayfasına yönlendir
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(plan: plan),
                      ),
                    );
                  } catch (e) {
                    print(e.toString());
                    // Hata durumunda kullanıcıya mesaj göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );

                  }
                }
              },
            ),
          ],
        ),
      ),
        ),
    ),
    );
  }
}
