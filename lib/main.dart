import 'package:flutter/material.dart';
import 'pages/notes_page.dart';

void main() => runApp(const ApiNotesApp());

class ApiNotesApp extends StatelessWidget {
  const ApiNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const NotesPage(), 
    );
  }
}