import '../models/note.dart';
import 'api_client.dart';

class NotesRepository {
  final ApiClient _client;
  NotesRepository(this._client);

  Future<List<Note>> list({int page = 1, int limit = 20}) async {
    final resp = await _client.dio.get(
      '/posts',
      queryParameters: {'_page': page, '_limit': limit},
    );
    final data = resp.data as List<dynamic>;
    return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Note> get(int id) async {
    final resp = await _client.dio.get('/posts/$id');
    return Note.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<Note> create(String title, String body) async {
    final resp = await _client.dio.post('/posts', data: {'title': title, 'body': body});
    return Note.fromJson(resp.data);
  }

  Future<void> delete(int id) async {
    await _client.dio.delete('/posts/$id');
  }
}