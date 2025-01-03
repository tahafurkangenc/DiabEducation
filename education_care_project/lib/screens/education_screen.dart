import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'diabetes_education_screen.dart';
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
                  _buildMenuButton('Diyabet', Icons.health_and_safety),
                  _buildMenuButton('Diyabette Beslenme', Icons.fastfood),
                  _buildMenuButton('Diyabette Egzersiz', Icons.directions_run),
                  _buildMenuButton('Diyabette Öz Bakım', Icons.spa),
                  _buildMenuButton('Diyabette İlaç Kullanımı', Icons.medical_services),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          if (text=="Diyabet"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiabetesEducationScreen()),
            );
          }
          if (text=="Diyabette Beslenme"){
            //Diyabette Beslenme
          }
          if (text=="Diyabette Egzersiz"){
            //Diyabette Egzersiz
          }
          if (text=="Diyabette Öz Bakım"){
            //Diyabette Öz Bakım
          }
          if (text=="Diyabette İlaç Kullanımı"){
            //Diyabette İlaç Kullanımı
          }
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // Buton rengi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}