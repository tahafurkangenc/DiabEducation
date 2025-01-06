import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:education_care_project/broadcastreceiver/connectivity_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'broadcastreceiver/connectivity_provider.dart'; //


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      //child: HealthExerciseApp(),
      child: EducationCareProject(),
    ),
  );
}


class EducationCareProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Exercise App',
      debugShowCheckedModeBanner: false, // Debug yazısını kaldırmak için
      theme: ThemeData(
        primarySwatch: Colors.blue, // Uygulama için genel bir renk teması
        fontFamily: 'Roboto', // Kullanmak istediğiniz fontu belirtin
      ),
      home:ConnectivityListener(
          child: LoginScreen()
      ) // Uygulamanın açılış ekranı
    );
  }
}

//TEST
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connectivity Test',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ConnectivityTest(),
    );
  }
}

class ConnectivityTest extends StatefulWidget {
  @override
  _ConnectivityTestState createState() => _ConnectivityTestState();
}

class _ConnectivityTestState extends State<ConnectivityTest> {
  String _connectionStatus = 'Bağlantı durumu bilinmiyor';
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result.toString();
      });
    });
  }

  Future<void> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bağlantı Durumu Testi'),
      ),
      body: Center(
        child: Text(
          _connectionStatus,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}