import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/notes_repository.dart';

class NoteDetailsPage extends StatelessWidget {
  final int id;
  final NotesRepository repo;

  const NoteDetailsPage({super.key, required this.id, required this.repo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: repo.get(id),
      builder: (context, snap) {
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Ошибка загрузки')),
          );
        }
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final n = snap.data!;
        return Scaffold(
          appBar: AppBar(title: Text('Запись #${n.id}')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(n.body),
              ],
            ),
          ),
        );
      },
    );
  }
}