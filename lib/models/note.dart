class Note {
  final int id;
  final String title;
  final String body;

  Note({required this.id, required this.title, required this.body});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : (json['id'] ?? 0),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
  };
}