import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:education_care_project/screens/education_market.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'diabetes_education_screen.dart';
import 'dart:convert'; // Türkçe karakter desteği için
class EducationScreen extends StatefulWidget {
  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final List<String> _videoIds = [
    'tZ8IFzpDxDE',
    'MpbooHx2LuQ',
    'JBJawbeZVUo',
    // Diğer video ID'lerini buraya ekleyin
  ];

  late List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _videoIds.map((videoId) => YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )).toList();
  }

  Future<bool> _isConnectedToWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eğitim Modülü'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Yatay Kaydırılabilir Video Listesi
            Container(
              height: 200,
              margin: EdgeInsets.all(16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300, // Genişliği ihtiyacınıza göre ayarlayabilirsiniz
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: YoutubePlayer(
                        controller: _controllers[index],
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.teal,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Butonlar
            Expanded(
              child: ListView(
                children: [
                  _buildMenuButton('Diyabet Eğitimi', Icons.health_and_safety ,Colors.teal as Color),
                  _buildMenuButton('Diyabette Beslenme', Icons.fastfood,Colors.teal as Color),
                  _buildMenuButton('Egzersiz', Icons.directions_run,Colors.teal as Color),
                  _buildMenuButton('Öz Bakım', Icons.spa,Colors.teal as Color),
                  _buildMenuButton('İlaç Kullanımı', Icons.medical_services,Colors.teal as Color),
                  _buildMenuButton("Eğitim Mağazası", Icons.shopping_bag_outlined, Colors.deepPurple as Color)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, Color buttoncolor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          if (text == "Eğitim Mağazası"){
            bool isWifi = await _isConnectedToWifi();
            if (isWifi) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EducationMarket()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wi-Fi bağlantınız yok. Eğitim Mağazası\'na erişmek için Wi-Fi\'ye bağlanın.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiabetesEducationScreen(category: text),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttoncolor as Color, // Buton rengi
          minimumSize: Size(150, 50), // Butonun genişlik ve yükseklik ayarı
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // İç kenar boşlukları
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Köşe yuvarlaklığı
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // İkon ve yazıyı karşıt kenarlara iter
          children: [
            // Yazı sola
            Text(
              text,
              style: TextStyle(
                fontSize: 20, // Yazı boyutunu büyüt
                color: Colors.white, // Yazı rengini beyaz yap
              ),
            ),
            // İkon sağa
            Icon(
              icon,
              color: Colors.white,
              size: 40, // İkon boyutu
            ),
          ],
        ),
      ),
    );

  }
}