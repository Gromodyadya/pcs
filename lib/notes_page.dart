import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _notesStream;

  @override
  void initState() {
    super.initState();
    final uid = supabase.auth.currentUser!.id;
    _notesStream = supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false);
  }

  Future<void> _createNote(String title, String content) async {
    await supabase.from('notes').insert({
      'title': title,
      'content': content,
      'user_id': supabase.auth.currentUser!.id,
    });
  }

  Future<void> _updateNote(String id, String title, String content) async {
    await supabase.from('notes').update({
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> _deleteNote(String id) async {
    await supabase.from('notes').delete().eq('id', id);
  }

  void _openNoteDialog({String? id, String? initialTitle, String? initialContent}) {
    final titleCtrl = TextEditingController(text: initialTitle);
    final contentCtrl = TextEditingController(text: initialContent);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(id == null ? 'Новая заметка' : 'Редактировать'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Заголовок')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Текст')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () async {
              if (id == null) {
                await _createNote(titleCtrl.text.trim(), contentCtrl.text.trim());
              } else {
                await _updateNote(id, titleCtrl.text.trim(), contentCtrl.text.trim());
              }
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => supabase.auth.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Ошибка: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final notes = snapshot.data!;
          if (notes.isEmpty) return const Center(child: Text('Заметок пока нет'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final note = notes[i];
              return Dismissible(
                key: ValueKey(note['id']),
                background: Container(color: Colors.red.withOpacity(0.2), alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.red)),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteNote(note['id']),
                child: Card(
                  child: ListTile(
                    title: Text(note['title'] ?? '(Без названия)'),
                    subtitle: Text(note['content'] ?? ''),
                    onTap: () => _openNoteDialog(
                      id: note['id'],
                      initialTitle: note['title'],
                      initialContent: note['content'],
                    ),
                    trailing: const Icon(Icons.edit_note),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

}
