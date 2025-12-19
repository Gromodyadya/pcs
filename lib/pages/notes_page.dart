import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Future<List<Note>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }


  void _reload() {
    setState(() {
      _future = DBHelper.fetchNotes();
    });
  }

  Future<void> _createDialog() async {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _EditDialog(titleCtrl: titleCtrl, bodyCtrl: bodyCtrl, title: 'Новая заметка'),
    );
    if (ok == true) {
      final now = DateTime.now();
      await DBHelper.insertNote(Note(
        title: titleCtrl.text.trim(),
        body: bodyCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
      ));
      _reload();
    }
  }

  Future<void> _editDialog(Note n) async {
    final titleCtrl = TextEditingController(text: n.title);
    final bodyCtrl = TextEditingController(text: n.body);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _EditDialog(titleCtrl: titleCtrl, bodyCtrl: bodyCtrl, title: 'Редактировать'),
    );
    if (ok == true) {
      await DBHelper.updateNote(n.copyWith(
        title: titleCtrl.text.trim(),
        body: bodyCtrl.text.trim(),
        updatedAt: DateTime.now(),
      ));
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes SQLite')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return const Center(child: Text('Ошибка загрузки'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final notes = snap.data!;
          if (notes.isEmpty) return const Center(child: Text('Пока нет заметок. Нажмите +'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final n = notes[i];
              return Dismissible(
                key: ValueKey(n.id),
                background: Container(color: Colors.red.withOpacity(0.1)),
                onDismissed: (_) async {
                  await DBHelper.deleteNote(n.id!);
                  _reload();
                },
                child: Card(
                  child: ListTile(
                    title: Text(n.title.isEmpty ? '(без названия)' : n.title),
                    subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => _editDialog(n),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await DBHelper.deleteNote(n.id!);
                        _reload();
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EditDialog extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController bodyCtrl;
  final String title;
  const _EditDialog({required this.titleCtrl, required this.bodyCtrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Заголовок')),
          TextField(controller: bodyCtrl, decoration: const InputDecoration(labelText: 'Текст')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Сохранить')),
      ],
    );
  }
}