import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const CameraApp());

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _checkPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _getImage(ImageSource source) async {
    await _checkPermissions();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveImage() async {
    if (_image == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newFile = await _image!.copy('${dir.path}/$fileName');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Сохранено: ${newFile.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Работа с камерой')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? const Text('Фото не выбрано')
                  : Image.file(_image!, width: 300, height: 300, fit: BoxFit.cover),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Сделать фото'),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text('Выбрать из галереи'),
              ),
              const SizedBox(height: 10),
              if (_image != null)
                ElevatedButton.icon(
                  onPressed: _saveImage,
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить фото'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}