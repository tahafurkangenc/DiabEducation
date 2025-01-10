import 'package:education_care_project/broadcastreceiver/connectivity_listener.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'form_screen.dart';
import 'education_screen.dart';
import 'getallprogresstest.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hoş bir AppBar ve arka plan tasarımı ekleyin
      appBar: AppBar(
        title: Text('Sağlıklı Yaşam'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await ApiService.auth_logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Başarıyla çıkış yaptınız')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Çıkış yaparken bir hata oluştu: $e')),
                );
              }
            },
          ),

        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // İki sütunlu grid
            crossAxisSpacing: 16, // Sütunlar arası boşluk
            mainAxisSpacing: 16, // Satırlar arası boşluk
            children: [
              // Egzersiz Planı Oluştur Kartı
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectivityListener(
                        child: FormScreen())
                    ),
                  );
                },
                child: Card(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Egzersiz Planı Oluştur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Diyabet Eğitim Portalı Kartı
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectivityListener(
                        child: EducationScreen())
                    ),
                  );
                },
                child: Card(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Diyabet Eğitim Portalı',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Tüm İlerlemenizi Görüntüleyin Kartı
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectivityListener(child: AllProgressScreen())),
                  );
                },
                child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.track_changes, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Tüm İlerlemenizi Görüntüleyin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}