import 'package:flutter/material.dart';
import '../models/module_progress.dart';
import '../providers/database_helper.dart';
import '../services/api_service.dart';

class ModuleProgressScreen extends StatefulWidget {
  final ModuleProgress module;
  final String categoryName;
  ModuleProgressScreen({required this.module, required this.categoryName});

  @override
  State<ModuleProgressScreen> createState() => _ModuleProgressScreenState();
}

class _ModuleProgressScreenState extends State<ModuleProgressScreen> {
  bool _isLoading = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Kullanıcı adını yükle
  }

  Future<void> _loadUsername() async {
    try {
      String? username = await ApiService.fetchUsername();
      setState(() {
        _username = username; // Kullanıcı adı state'e kaydedildi
      });

      // Kullanıcı adını ve modül bilgilerini kaydetmek
      if (username != null) {
        print("LOG->"+username + widget.module.name + widget.categoryName);
        await _logModuleEntry(username, widget.module.name, widget.categoryName);
      }
    } catch (e) {
      print('Kullanıcı adı yüklenirken hata: $e');
    }
  }
  
  Future<void> _logModuleEntry(String username, String moduleName, String categoryName) async {
    await DatabaseHelper.instance.upsertModuleLog(
      username,
      moduleName,
      categoryName,
      DateTime.now()
    );
    print('Module entry logged: ${widget.module.name}');
  }

  Future<void> _updateProgress(int progress, bool completed) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.updateProgress(
        widget.categoryName,
        widget.module.name,
        completed,
        progress,
        widget.module.topic,
      );

      print(widget.categoryName);
      print(widget.module.name);
      print(widget.module.topic);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme güncellendi: $progress%')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme güncellenirken hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProgress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.deleteProgress(
        widget.categoryName,
        widget.module.name,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme silindi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme silinirken hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.name),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '${widget.module.name} Modülü',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(
                  onPressed: () => _updateProgress(50, false),
                  child: Text('İlerlemeyi %50 Güncelle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _updateProgress(100, true),
                  child: Text('Modülü Tamamla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _deleteProgress,
                  child: Text('İlerlemeyi Sil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


