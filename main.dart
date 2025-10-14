// lib/main.dart

import 'package:flutter/material.dart';
import 'models/note.dart';
import 'edit_note_page.dart';

void main() => runApp(const SimpleNotesApp());

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Исходный список всех заметок
  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Первая заметка',
      body: 'Это пример заметки для демонстрации.',
    ),
    Note(id: '2', title: 'Список покупок', body: 'Молоко, хлеб, яйца.'),
    Note(
      id: '3',
      title: 'Идеи для проекта',
      body: 'Реализовать поиск и свайп.',
    ),
  ];

  // Список для отображения (может быть отфильтрован)
  List<Note> _filteredNotes = [];

  // Состояние для управления отображением поиска
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Изначально отображаем все заметки
    _filteredNotes = _notes;
    // Добавляем слушатель для поля поиска
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterNotes);
    _searchController.dispose();
    super.dispose();
  }

  // Метод для фильтрации заметок
  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        final titleLower = note.title.toLowerCase();
        return titleLower.contains(query);
      }).toList();
    });
  }

  // Переключение между обычным AppBar и поиском
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Очистка поиска при выходе
      }
    });
  }

  // Переход на экран для добавления новой заметки
  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const EditNotePage()),
    );
    if (newNote != null) {
      setState(() {
        _notes.add(newNote);
        _filterNotes(); // Обновляем отфильтрованный список
      });
    }
  }

  // Переход на экран для редактирования существующей заметки
  Future<void> _edit(Note note) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(existing: note)),
    );
    if (updated != null) {
      setState(() {
        final i = _notes.indexWhere((n) => n.id == updated.id);
        if (i != -1) _notes[i] = updated;
        _filterNotes(); // Обновляем отфильтрованный список
      });
    }
  }

  // Удаление заметки
  void _delete(Note note) {
    final noteId = note.id;
    setState(() {
      // Удаляем из обоих списков, чтобы избежать ошибок
      _notes.removeWhere((n) => n.id == noteId);
      _filteredNotes.removeWhere((n) => n.id == noteId);
    });
    // Показываем уведомление
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Заметка удалена')));
  }

  // Создание обычного AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Simple Notes'),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: _toggleSearch),
      ],
    );
  }

  // Создание AppBar с полем поиска
  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _toggleSearch,
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Поиск по заголовку...',
          border: InputBorder.none,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _searchController.clear(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildAppBar(),
      body: _filteredNotes.isEmpty
          ? const Center(child: Text('Заметок не найдено.'))
          : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, i) {
                final note = _filteredNotes[i];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(note),
                  background: Container(
                    color: Colors.red.shade400,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title.isEmpty ? '(без названия)' : note.title,
                    ),
                    subtitle: Text(
                      note.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _edit(note),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(note),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
