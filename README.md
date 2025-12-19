# ОТЧЕТ ПО ПРАКТИЧЕСКОЙ РАБОТЕ №11
**Тема:** Работа с базами данных. Основы работы с API (HTTP/REST) для Flutter
---

## 1. Цели работы
*   Понять базовые понятия HTTP/REST: методы, URL, коды ответов, JSON.
*   Освоить интеграцию Flutter-приложения с внешним API с использованием библиотеки `dio`.
*   Научиться выстраивать слой данных с использованием паттерна «Репозиторий».
*   Реализовать пагинацию, обработку ошибок и сетевых таймаутов.
*   Обеспечить качественный UX при выполнении сетевых операций.

---

## 2. Ход работы

### 2.1. Используемый API
В работе использован **Вариант А (JSONPlaceholder)**.
*   **Базовый URL:** `https://jsonplaceholder.typicode.com`
*   **Примеры эндпоинтов:**
    *   `GET /posts?_page=1&_limit=20` — получение списка постов с пагинацией.
    *   `GET /posts/{id}` — получение деталей конкретной записи.
    *   `POST /posts` — создание новой записи (имитация).

### 2.2. Архитектура приложения
Приложение разделено на слои согласно принципу разделения ответственности:
1.  **UI слой**: Виджеты страниц (`NotesPage`, `NoteDetailsPage`).
2.  **Слой данных (Repository)**: Класс `NotesRepository`, отвечающий за бизнес-логику данных.
3.  **Сетевой слой (API Client)**: Настройка `Dio` в классе `ApiClient`.

### 2.3. Ключевые фрагменты кода

**Файл `lib/data/api_client.dart` (Настройка Dio):**
```dart
// Настройка таймаутов и базовых параметров
final dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {'Content-Type': 'application/json'},
));
```

**Файл `lib/data/notes_repository.dart` (Методы API):**
```dart
Future<List<Note>> list({int page = 1, int limit = 20}) async {
  final resp = await _client.dio.get('/posts', 
    queryParameters: {'_page': page, '_limit': limit});
  final data = resp.data as List<dynamic>;
  return data.map((e) => Note.fromJson(e)).toList();
}
```

**Файл `lib/models/note.dart` (Модель):**
```dart
factory Note.fromJson(Map<String, dynamic> json) {
  return Note(
    id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : (json['id'] ?? 0),
    title: json['title'] ?? '',
    body: json['body'] ?? '',
  );
}
```

---

## 3. Реализация функций

### 3.1. Пагинация и UX
Пагинация реализована через бесконечный скролл. В `ListView.separated` добавлен дополнительный элемент в конец списка: если `_canLoadMore` истинно, отображается `CircularProgressIndicator`, и вызывается метод `_loadMore()`.
*   **Loading:** Состояние отслеживается переменной `_loading`. Пока данные первой страницы не получены, отображается центральный индикатор загрузки.
*   **Empty/Error:** При возникновении исключений в блоке `catch` пользователю выводится `SnackBar` с текстом «Ошибка загрузки».

### 3.2. Трудности и решения
1.  **Ошибка "setState() called during build":** Возникала при автоматическом вызове подгрузки данных внутри `itemBuilder`. **Решение:** Использование `Future.microtask(() => _loadMore())` для выноса обновления состояния в следующий цикл событий.
---

## 4. Скриншоты

**4.1. Скриншот экрана списка (данные получены из API):**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/ca24c6b1-3210-466d-96b8-295236c21b55" />

**4.2. Скриншот экрана деталей (просмотр существующей записи):**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/730f68fc-8fec-4b11-806f-e53af085c404" />

**4.3. Скриншот диалога создания записи:**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/b0910971-ce4c-4af4-bda7-7595330eb589" />

**4.4. Результат создания (новая запись появилась в списке):**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/693f486a-56f6-49c4-8a14-4df4f2ec13fb" />

---

## 5. Выводы
В ходе выполнения работы были изучены принципы взаимодействия Flutter-приложения с внешними сервисами по протоколу HTTP. Были освоены навыки работы с библиотекой `Dio`, сериализации JSON данных в объекты Dart и реализации паттерна «Репозиторий». Особое внимание было уделено обработке состояний сети и обеспечению плавного UX через механизмы бесконечной прокрутки и обработки ошибок.
