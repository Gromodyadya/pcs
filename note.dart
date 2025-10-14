

class Note {
  final String id;
  final String title;
  final String body;

  Note({
    required this.id,
    required this.title,
    required this.body,
  });


  Note copyWith({String? title, String? body}) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

}
