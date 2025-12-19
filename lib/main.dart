import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';

void main() => runApp(const GeoSensorsApp());

class GeoSensorsApp extends StatelessWidget {
  const GeoSensorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo & Sensors',
      theme: ThemeData(useMaterial3: true),
      home: const GeoSensorsPage(),
    );
  }
}

class GeoSensorsPage extends StatefulWidget {
  const GeoSensorsPage({super.key});

  @override
  State<GeoSensorsPage> createState() => _GeoSensorsPageState();
}

class _GeoSensorsPageState extends State<GeoSensorsPage> {
  Position? _position;
  String _address = '–';
  double? _compass;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Службы геолокации отключены.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('В разрешении отказано.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Разрешения отклонены навсегда. Измените их в настройках.');
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      
      setState(() {
        _position = pos;
        if (placemarks.isNotEmpty) {
          _address =
              '${placemarks.first.locality ?? ''}, ${placemarks.first.street ?? ''}';
        }
      });
    } catch (e) {
      setState(() {
        _position = pos;
        _address = 'Не удалось определить адрес';
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _accelSubscription = accelerometerEvents.listen((event) {
      if (mounted) {
        setState(() => _accelerometerValues = [event.x, event.y, event.z]);
      }
    });

    _gyroSubscription = gyroscopeEvents.listen((event) {
      if (mounted) {
        setState(() => _gyroscopeValues = [event.x, event.y, event.z]);
      }
    });

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() => _compass = event.heading);
      }
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geo & Sensors Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Определить местоположение'),
            ),
            const SizedBox(height: 12),
            Text(
              _position != null
                  ? 'Координаты: ${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)}'
                  : 'Координаты: –',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Адрес: $_address', style: const TextStyle(fontSize: 16)),
            const Divider(height: 30, thickness: 2),
            Text(
              'Компас: ${_compass?.toStringAsFixed(2) ?? '–'}°',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Акселерометр (X, Y, Z):'),
            Text(
              _accelerometerValues
                      ?.map((e) => e.toStringAsFixed(2))
                      .join(', ') ??
                  '–',
            ),
            const SizedBox(height: 10),
            const Text('Гироскоп (X, Y, Z):'),
            Text(
              _gyroscopeValues
                      ?.map((e) => e.toStringAsFixed(2))
                      .join(', ') ??
                  '–',
            ),
          ],
        ),
      ),
    );
  }
}