// lib/edit_note_page.dart

import 'package:flutter/material.dart';
import 'models/note.dart';

class EditNotePage extends StatefulWidget {
  // Принимает существующую заметку для редактирования. Если null — создается новая.
  final Note? existing;

  const EditNotePage({super.key, this.existing});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _body;
  late bool _isEdit;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.existing != null;
    _title = widget.existing?.title ?? '';
    _body = widget.existing?.body ?? '';
  }

  void _save() {
    // Проверяем, прошли ли все поля формы валидацию
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Сохраняем значения из полей формы в переменные
    _formKey.currentState!.save();

    final result = _isEdit
        ? widget.existing!.copyWith(title: _title, body: _body)
        : Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _title,
            body: _body,
          );

    // Возвращаем результат (новую или обновленную заметку) на предыдущий экран
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Редактировать' : 'Новая заметка')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                onSaved: (v) => _title = v?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _body,
                decoration: const InputDecoration(
                  labelText: 'Текст',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 6,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Введите текст заметки';
                  }
                  return null;
                },
                onSaved: (v) => _body = v?.trim() ?? '',
              ),
              const Spacer(), // Занимает всё свободное место
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Сохранить'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    50,
                  ), // Кнопка на всю ширину
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
