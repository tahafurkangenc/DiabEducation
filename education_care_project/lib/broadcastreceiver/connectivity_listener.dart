import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'connectivity_provider.dart'; // ConnectivityProvider sınıfı

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  ConnectivityListener({required this.child});

  @override
  _ConnectivityListenerState createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectivityProvider>(context).isConnected;

    if (!isConnected) {
      // İnternet bağlantısı kesildiğinde bir uyarı gösterebilirsiniz
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İnternet bağlantısı kesildi.'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }

    return widget.child;
  }
}
