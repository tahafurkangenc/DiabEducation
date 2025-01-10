import 'package:education_care_project/screens/tmp_educationpage_screen.dart';
import 'package:flutter/material.dart';
import '../models/category_progress.dart';
import '../models/module_progress.dart';
import '../services/api_service.dart';

class DiabetesEducationScreen extends StatefulWidget {
  final String category; // Kategori parametresi

  DiabetesEducationScreen({required this.category});

  @override
  State<DiabetesEducationScreen> createState() => _DiabetesEducationScreen();
}

class _DiabetesEducationScreen extends State<DiabetesEducationScreen> {
  List<ModuleProgress> modules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    try {
      final categoryProgress = await ApiService.getCategoryProgress(widget.category);
      setState(() {
        modules = categoryProgress.modules;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eğitim bilgileri alınırken bir hata oluştu: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} '),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                '${widget.category} Eğitim Programı',
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

  Widget _buildEducationButton(ModuleProgress module) {
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
            print('Navigating to: ${module.topic}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleProgressScreen(
                  module: module, // ModuleProgress tipinde
                  categoryName: widget.category, // Kategorinin ismi
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: module.completionPercentage / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${module.completionPercentage}% Tamamlandı',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
