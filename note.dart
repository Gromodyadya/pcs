// lib/models/note.dart

class Note {
  final String id;
  final String title;
  final String body;

  Note({
    required this.id,
    required this.title,
    required this.body,
  });

  // Метод для создания копии объекта с возможностью изменения полей.
  // Это полезно для сохранения иммутабельности (неизменяемости) объектов.
  Note copyWith({String? title, String? body}) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}