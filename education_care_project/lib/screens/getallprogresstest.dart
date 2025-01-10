import 'package:flutter/material.dart';
import '../providers/database_helper.dart';

class AllProgressScreen extends StatefulWidget {
  @override
  _AllProgressScreenState createState() => _AllProgressScreenState();
}

class _AllProgressScreenState extends State<AllProgressScreen> {
  late Future<List<Map<String, dynamic>>> _futureProgress;

  @override
  void initState() {
    super.initState();
    _futureProgress = DatabaseHelper.instance.getAllLogsWithLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm İlerlemeler'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureProgress,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç ilerleme bulunamadı.'));
          } else {
            List<Map<String, dynamic>> logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text('Modül: ${log['module_name']}'),
                  subtitle: Text('Kategori: ${log['category_name']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Zaman: ${log['entry_time']}'),
                      Text(
                          'Konum: ${log['latitude']}, ${log['longitude']}'), // Konum bilgisi
                    ],
                  ),
                  leading: CircleAvatar(
                    child: Text('${log['user_id']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
