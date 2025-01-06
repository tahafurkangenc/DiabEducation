import 'package:location/location.dart';

class LocationService {
  static final Location _location = Location();

  static Future<Map<String, double>?> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Konum servisini kontrol et
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null; // Kullanıcı konum servisini açmadı
      }
    }

    // İzinleri kontrol et
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null; // İzin verilmedi
      }
    }

    // Konum bilgilerini al
    final locationData = await _location.getLocation();
    return {
      'latitude': locationData.latitude!,
      'longitude': locationData.longitude!,
    };
  }
}
