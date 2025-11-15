import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Контроллеры для полей ввода
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  // Получаем доступ к коллекции 'notes' в Firestore
  final CollectionReference _notesCollection = FirebaseFirestore.instance
      .collection('notes');

  // Функция для отображения диалога (для создания или редактирования)
  Future<void> _showFormDialog([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    // Если есть documentSnapshot, значит это редактирование
    if (documentSnapshot != null) {
      action = 'update';
      _titleCtrl.text = documentSnapshot['title'];
      _contentCtrl.text = documentSnapshot['content'];
    } else {
      // Если нет, это создание новой заметки
      _titleCtrl.clear();
      _contentCtrl.clear();
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            action == 'create' ? 'Новая заметка' : 'Редактировать заметку',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Заголовок'),
              ),
              TextField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'Содержание'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(action == 'create' ? 'Создать' : 'Обновить'),
              onPressed: () async {
                final String title = _titleCtrl.text.trim();
                final String content = _contentCtrl.text.trim();

                if (title.isNotEmpty) {
                  if (action == 'create') {
                    // Создаем новую заметку
                    await _notesCollection.add({
                      "title": title,
                      "content": content,
                      "createdAt": Timestamp.now(),
                    });
                  } else if (action == 'update') {
                    // Обновляем существующую заметку
                    await _notesCollection.doc(documentSnapshot!.id).update({
                      "title": title,
                      "content": content,
                    });
                  }

                  // Очищаем поля и закрываем диалог
                  _titleCtrl.clear();
                  _contentCtrl.clear();
                  if (mounted) Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Функция для удаления заметки
  Future<void> _deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();

    // Показываем подтверждение
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заметка успешно удалена')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Заметки')),
      // Используем StreamBuilder для получения данных в реальном времени
      body: StreamBuilder(
        // Сортируем заметки по дате создания в убывающем порядке
        stream: _notesCollection
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (streamSnapshot.hasError) {
            return const Center(child: Text('Что-то пошло не так'));
          }
          if (streamSnapshot.hasData && streamSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Пока нет заметок'));
          }

          final notes = streamSnapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(document['title']),
                  subtitle: Text(document['content']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        // Кнопка для редактирования
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showFormDialog(document),
                        ),
                        // Кнопка для удаления
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(document.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Кнопка для добавления новой заметки
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
