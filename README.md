# ОТЧЕТ ПО ПРАКТИЧЕСКОМУ ЗАНЯТИЮ № 9
**Тема:** Работа с базами данных. Подключение приложения к Supabase (Flutter)
---

### Описание реализации проекта

*   **Как подключали Supabase:**
    1.  Зарегистрирован проект на платформе [supabase.com](https://supabase.com).
    2.  В разделе **Project Settings -> API** были получены данные для интеграции:
        *   **Project URL:** Адрес вида `https://[PROJECT_REF].supabase.co`, используемый для маршрутизации запросов к API.
        *   **Anon (public) key:** Публичный ключ, позволяющий выполнять запросы от имени клиента с учетом правил RLS.
    3.  В настройках **Authentication -> Providers** был отключен параметр "Confirm email" для упрощения процесса отладки регистрации.
    4.  Для безопасности приватный ключ `service_role` не публиковался и не использовался в коде приложения.

*   **Какие зависимости и где инициализация:**
    *   **Зависимости:** В файле `pubspec.yaml` в секции `dependencies` добавлен официальный пакет:
        ```yaml
        supabase_flutter: ^2.0.0
        ```
    *   **Инициализация:** Выполняется в файле `lib/main.dart` внутри асинхронной функции `main()` до вызова `runApp()`. Это гарантирует, что клиент Supabase будет готов к работе сразу после запуска приложения:
        ```dart
        void main() async {
          WidgetsFlutterBinding.ensureInitialized();
          await Supabase.initialize(
            url: 'SUPABASE_URL',
            anonKey: 'SUPABASE_ANON_KEY',
          );
          runApp(const NotesApp());
        }
        ```

*   **Структура таблицы и RLS-политики:**
    *   **Структура таблицы `notes`:**
        *   `id` (uuid, PK): уникальный идентификатор, генерируемый через `gen_random_uuid()`.
        *   `user_id` (uuid, nullable = false): идентификатор владельца записи (связь с таблицей `auth.users`).
        *   `title` (text): заголовок заметки.
        *   `content` (text): содержимое заметки.
        *   `created_at`, `updated_at` (timestamptz): метки времени для отслеживания изменений.
    *   **RLS-политики:**
        На таблице включен механизм **Row Level Security**. Созданы политики для всех CRUD-операций:
        1.  `SELECT`: разрешен только если `auth.uid() = user_id`.
        2.  `INSERT`: разрешен только с автоматической подстановкой или проверкой `auth.uid()` в поле `user_id`.
        3.  `UPDATE/DELETE`: разрешены только владельцу записи (проверка по `auth.uid()`).

*   **С какими ошибками столкнулись и как решили:**
    1.  **AuthWeakPasswordException:** При регистрации приложение выдавало ошибку и падало, если пароль был короче 6 символов.
        *Решение:* В код была добавлена обработка исключений (try-catch) и уведомление пользователя о необходимости ввода более длинного пароля.
    2.  **Отсутствие обновлений Realtime:** После добавления заметки список в приложении не обновлялся без перезахода.
        *Решение:* В Dashboard Supabase (раздел Database -> Replication) таблица `notes` была добавлена в публикацию `supabase_realtime`, что позволило методу `.stream()` корректно получать уведомления об изменениях.
    3.  **Permission denied при чтении:** Приложение не видело заметок даже после их создания.
        *Решение:* Проверена работа RLS. Ошибка была в отсутствии политики `SELECT`. После добавления SQL-запроса на создание политики для чтения, данные стали отображаться корректно.

---

Для оформления отчета тебе нужно не просто вставить картинки, а подписать их правильными техническими терминами из методички. Вот готовые описания для твоих скриншотов:

---

### Описания к скриншотам

**Рис. 1. Настройка базы данных в Supabase Dashboard.**

<img width="1280" height="472" alt="image" src="https://github.com/user-attachments/assets/c24bb68a-cacd-49ac-ad38-84ca948f34c6" />

<img width="798" height="456" alt="image" src="https://github.com/user-attachments/assets/ddc303ac-5246-4cf7-b645-a9163f50c317" />

<img width="1616" height="851" alt="image" src="https://github.com/user-attachments/assets/4c865921-bb62-4286-bbd2-ea3dce9a00f3" />

**Рис. 3. Экран аутентификации в приложении.**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/aff4ddd6-0ad0-4782-baa4-7cd3207b778c" />

**Рис. 4. Работа с пустым списком и реактивное добавление данных.**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/4f7b1e83-8740-4025-8e61-53390c574589" />

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/e85e0978-ffdf-48d6-8bdf-96f10f8ba4ef" />

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/971cedc1-9e8f-4878-9180-a76c0cf3af8b" />

**Рис. 5. Реализация CRUD-операций: редактирование и удаление.**

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/dddd6e73-9ccc-4a2c-b5a7-06f289043fea" />

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/3c2dcbb7-032e-4919-90f3-9382cadcc0a8" />

<img width="1280" height="167" alt="image" src="https://github.com/user-attachments/assets/4693b16a-d318-45f7-83f8-c32631824c23" />
