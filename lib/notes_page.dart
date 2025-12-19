import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _db = FirebaseFirestore.instance;
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  // Создание заметки
  Future<void> _createNote() async {
    if (_titleCtrl.text.isEmpty) return;
    await _db.collection('notes').add({
      'title': _titleCtrl.text.trim(),
      'content': _contentCtrl.text.trim(),
      'createdAt': Timestamp.now(),
    });
    _titleCtrl.clear();
    _contentCtrl.clear();
    if (mounted) Navigator.pop(context);
  }

  // Удаление заметки
  Future<void> _deleteNote(DocumentReference ref) async {
    await ref.delete();
  }

  // Диалог создания
  void _openCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Новая заметка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Заголовок')),
            TextField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'Текст')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          FilledButton(onPressed: _createNote, child: const Text('Сохранить')),
        ],
      ),
    );
  }

  // Диалог редактирования
  void _openEditDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    _titleCtrl.text = data['title'] ?? '';
    _contentCtrl.text = data['content'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Редактировать заметку'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Заголовок')),
            TextField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'Текст')),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            _titleCtrl.clear();
            _contentCtrl.clear();
            Navigator.pop(context);
          }, child: const Text('Отмена')),
          FilledButton(
            onPressed: () async {
              await _updateNote(doc.reference, _titleCtrl.text, _contentCtrl.text);
              _titleCtrl.clear();
              _contentCtrl.clear();
              if (mounted) Navigator.pop(context);
            }, 
            child: const Text('Обновить')
          ),
        ],
      ),
    );
  }

  // Сама логика обновления в базе
  Future<void> _updateNote(DocumentReference ref, String title, String content) async {
    await ref.update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Notes'), backgroundColor: Colors.blue.shade100),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('notes').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Ошибка загрузки'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('Пока нет заметок'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(data['title'] ?? '(Без названия)'),
                  subtitle: Text(data['content'] ?? ''),
                  onTap: () => _openEditDialog(doc),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(doc.reference),
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