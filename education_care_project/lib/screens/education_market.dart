import 'package:flutter/material.dart';
import 'dart:convert'; // Türkçe karakter desteği için
import '../services/api_service.dart';

class EducationMarket extends StatefulWidget {
  @override
  _EducationMarketState createState() => _EducationMarketState();
}

class _EducationMarketState extends State<EducationMarket> {
  List<dynamic> educations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEducations();
  }

  Future<void> _fetchEducations() async {
    try {
      final data = await ApiService.getAllEducations();
      setState(() {
        educations = data.map((e) => jsonDecode(utf8.decode(jsonEncode(e).codeUnits))).toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eğitimler alınırken hata oluştu: $e')),
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
        title: Text('Eğitim Mağazası'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Önerilen Eğitimler
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Önerilen Eğitimler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: 200,
            child: educations.isEmpty
                ? Center(child: Text('Hiç eğitim bulunamadı.'))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: educations.length > 3 ? 3 : educations.length, // İlk 3 öneri
              itemBuilder: (context, index) {
                final education = educations[index];
                return _buildEducationCard(education);
              },
            ),
          ),
          Divider(),
          // Tüm Eğitimler
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tüm Eğitimler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: educations.isEmpty
                ? Center(child: Text('Hiç eğitim bulunamadı.'))
                : ListView.builder(
              itemCount: educations.length,
              itemBuilder: (context, index) {
                final education = educations[index];
                return _buildEducationTile(education);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(dynamic education) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 40, color: Colors.teal),
            SizedBox(height: 10),
            Flexible(
              child: Text(
                education['title'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Overflow sorunu çözüldü
                maxLines: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${education['category']}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '${education['instructor']}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEducationTile(dynamic education) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(Icons.school, color: Colors.teal),
        title: Text(education['title']),
        subtitle: Text('${education['category']} - ${education['instructor']}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          try {
            bool success = await ApiService.addToProgress(education['title']);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Eğitim başarıyla eklendi')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: $e')),
            );
          }
        },
      ),
    );
  }

}
