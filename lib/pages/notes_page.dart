import 'package:flutter/material.dart';
import '../data/api_client.dart';
import '../data/notes_repository.dart';
import '../models/note.dart';
import 'note_details_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesRepository repo;
  final List<Note> _items = [];
  int _page = 1;
  bool _canLoadMore = true;
  bool _loading = false;

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать запись'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Текст'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNote = await repo.create(
                titleController.text,
                bodyController.text,
              );

              setState(() {
                _items.insert(0, newNote);
              });

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Запись создана (имитация)')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final client = ApiClient(baseUrl: 'https://jsonplaceholder.typicode.com');
    repo = NotesRepository(client);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _page = 1;
      _canLoadMore = true;
      _items.clear();
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (!_canLoadMore || _loading) return;
    setState(() => _loading = true);
    try {
      final batch = await repo.list(page: _page, limit: 15);
      setState(() {
        _items.addAll(batch);
        _canLoadMore = batch.isNotEmpty && _items.length < 100;
        if (_canLoadMore) _page++;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка загрузки')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Notes Feed')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _items.isEmpty && _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _items.length + (_canLoadMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  if (i == _items.length) {
                    Future.microtask(() => _loadMore()); 
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final n = _items[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListTile(
                      title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => NoteDetailsPage(id: n.id, repo: repo)
                      )),
                    ),
                  );
                },
              ),
      ),
    );
  }
}