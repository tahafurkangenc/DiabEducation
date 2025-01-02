import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'education_screen.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hoş bir AppBar ve arka plan tasarımı ekleyin
      appBar: AppBar(
        title: Text('Sağlıklı Yaşam'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Egzersiz Planı Oluştur'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Diyabet Eğitim Portalı'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EducationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
