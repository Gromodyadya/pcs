import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Firebase с автоматически сгенерированными опциями
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Указываем наш главный экран
      home: const NotesPage(),
    );
  }
}
