# Отчет по практической работе №8
## Тема: Работа с базами данных. Подключение приложения к Firebase
---

### 1. Подключение и привязка к Firebase
Для настройки связи между Flutter-приложением и облачной платформой были выполнены следующие действия:
1. В консоли Firebase создан проект с уникальным ID: `farebase-notes-alekslylin`.
2. Установлен и активирован инструмент **FlutterFire CLI** через команду `dart pub global activate flutterfire_cli`.
3. Выполнена привязка проекта к коду командой `flutterfire configure`. В результате в директории `lib/` автоматически сгенерирован файл конфигурации `firebase_options.dart`.

### 2. Используемые пакеты и инициализация
В файл конфигурации зависимостей `pubspec.yaml` были добавлены следующие пакеты:
* `firebase_core`: ^3.6.0 (основное ядро Firebase).
* `cloud_firestore`: ^5.4.4 (библиотека для работы с БД Firestore).

**Инициализация Firebase** происходит в точке входа `main.dart` асинхронно перед запуском приложения:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NotesApp());
}
```

### 3. Структура коллекции и документов
База данных организована по модели NoSQL (документо-ориентированная):
* **Название коллекции:** `notes`
* **Поля в документе:**
  * `title` (string) — заголовок заметки;
  * `content` (string) — содержание заметки;
  * `createdAt` (timestamp) — метка времени создания (используется для сортировки списка).

### 4. Правила безопасности
Для выполнения учебного задания в Cloud Firestore были установлены правила доступа в тестовом режиме:
```javascript
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
**Анализ безопасности:** Данные правила **недопустимы для продакшена**, так как любой пользователь интернета может получить полный доступ к данным (чтение и удаление) без авторизации. В реальном проекте необходимо использовать `firebase_auth` и ограничить доступ правилом `if request.auth != null`.

### 5. Решение проблем и диагностика
В ходе выполнения практической работы были выявлены и решены следующие проблемы:
1. **Отсутствие путей в PATH:** Команда `flutterfire` не распознавалась. Решено добавлением пути к папке `Pub/Cache/bin` в переменные среды Windows.
2. **Конфликт ID проекта:** Идентификатор `firebase-notes-app` был занят. После создания уникального ID проблема не ушла. Помогло создание проекта на сайте.
3. **minSdkVersion:** Приложение не запускалось на Android. В файле `android/app/build.gradle` параметр был изменен на `23`.
4. **Телефон не подключался:** Устройство не определялось через USB. Проблема решена сменой режима USB на "Передача файлов" и активацией "Отладки по USB".

### 6. Скриншоты

1. **Настроенный проект Firebase:**
  <img width="1280" height="694" alt="image" src="https://github.com/user-attachments/assets/f7efb2eb-237d-47f0-8cb6-6e7c97ac9635" />


2. **Запущенное приложение (пустой список):**
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/5971f98b-4324-476e-a75b-63f544a4663b" />


3. **Скриншоты добавления заметки:**
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/44242031-6515-4d44-b395-2c7c70674085" />
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/03781557-9aba-4fc9-8292-3257d92c18ab" />
   <img width="1280" height="565" alt="image" src="https://github.com/user-attachments/assets/fecc6ce9-ec16-4fdd-ad94-02f4bf066534" />


4. **Окно редактирования заметки и после редактирования:**
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/87d4eaf0-cf88-4585-981d-1dda7b0128b9" />
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/2a80c3d4-20ba-4bd4-b408-852e427a2a0b" />
   <img width="1280" height="562" alt="image" src="https://github.com/user-attachments/assets/1ae1f3ca-722f-4cdd-8144-bb762919f072" />


5. **Список до и после удаления элемента:**
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/d0641f9a-ce03-495c-b599-dcca293d586d" />
   <img width="1280" height="290" alt="image" src="https://github.com/user-attachments/assets/8c144228-5319-49a0-8327-03fe1fcc5897" />
   <img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/5d934406-5f70-44aa-981e-7efdf5419a30" />
   <img width="1280" height="278" alt="image" src="https://github.com/user-attachments/assets/c3544f62-fa76-4b1e-994a-6b1fe7febc8c" />

