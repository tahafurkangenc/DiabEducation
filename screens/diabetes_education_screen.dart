import 'package:flutter/material.dart';

import 'diabetes_education_screens/diabetes-intro.dart';

// Eğitim modülü için veri modeli
class EducationModule {
  final String title;
  final IconData icon;
  final double progress; // 0.0 ile 1.0 arası
  final String route;

  EducationModule({
    required this.title,
    required this.icon,
    required this.progress,
    required this.route,
  });
}

class DiabetesEducationScreen extends StatefulWidget {
  @override
  State<DiabetesEducationScreen> createState() => _DiabetesEducationScreen();
}

class _DiabetesEducationScreen extends State<DiabetesEducationScreen> {
  // Eğitim modülleri (FastAPI'den gelecek veriyi simüle eder)
  final List<EducationModule> modules = [
    EducationModule(
      title: 'Diyabet Nedir?',
      icon: Icons.info,
      progress: 0.7,
      route: '/diabetes-intro',
    ),
    EducationModule(
      title: 'Tip 1 Diyabet İçin Ölçüm Cihazı',
      icon: Icons.devices,
      progress: 0.4,
      route: '/measurement-device',
    ),
    EducationModule(
      title: 'Cilt Alt Ölçümü',
      icon: Icons.opacity,
      progress: 0.2,
      route: '/skin-measurement',
    ),
    EducationModule(
      title: 'Enjeksiyon',
      icon: Icons.medical_services,
      progress: 0.5,
      route: '/injection',
    ),
    EducationModule(
      title: 'Hiperglisemi',
      icon: Icons.warning,
      progress: 0.6,
      route: '/hyperglycemia',
    ),
    EducationModule(
      title: 'Hipoglisemi',
      icon: Icons.health_and_safety,
      progress: 0.3,
      route: '/hypoglycemia',
    ),
    EducationModule(
      title: 'İnsülin Çantası',
      icon: Icons.shopping_bag,
      progress: 0.8,
      route: '/insulin-bag',
    ),
  ];

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
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Diyabet Eğitim Programı',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  return _buildEducationButton(modules[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationButton(EducationModule module) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if(module.route=='/diabetes-intro'){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => diabetes_introScreen()),
              );
            }
            // Burada route navigation işlemi yapılacak
            print('Navigating to: ${module.route}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  module.icon,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: module.progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${(module.progress * 100).toInt()}% Tamamlandı',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
