
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/database_helper.dart';

const String taskName = "backgroundTask";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Arka plan işleyicisi
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      final dbHelper = DatabaseHelper.instance;
      
      // Veritabanından en eski kaydı al
      final log = await dbHelper.getEarliestLogWithLocation();
      
      if (log != null) {
        await flutterLocalNotificationsPlugin.show(
          0,
          'Hatırlatma',
          'Modül: ${log['module_name']}\nKategori: ${log['category_name']}\nKonum: ${log['latitude']}, ${log['longitude']}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel_id',
              'Hatırlatma Kanalı',
              channelDescription: 'Hatırlatmalar için bildirim kanalı',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    }
    return Future.value(true);
  });
}

/// Bildirimleri başlatma
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

/// WorkManager'ı başlatma ve görevi kaydetme
Future<void> startBackgroundService() async {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  
  await Workmanager().registerPeriodicTask(
    '1',
    taskName,
    frequency: const Duration(minutes: 15), // Görev sıklığı
  );
}
