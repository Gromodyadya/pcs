# Отчет по практической работе №12 
**Тема:** Работа с камерой и аппаратной частью устройства во Flutter  

---

### 1. Цели работы
*   Изучить архитектуру и возможности аппаратной части мобильных устройств.
*   Ознакомиться с API камеры и галереи во Flutter.
*   Научиться создавать приложения, использующие камеру и хранилище устройства.
*   Разобраться с разрешениями (permissions), обработкой изображений и сохранением данных.

---

### 2. Ход выполнения

#### Шаг 1: Подготовка проекта и установка зависимостей
Был создан новый проект `camera_app`. В файл `pubspec.yaml` были добавлены необходимые плагины для работы с камерой, разрешениями и файловой системой:

```yaml
dependencies:
  image_picker: ^1.1.1       # Для выбора фото из камеры/галереи
  permission_handler: ^11.3.0 # Для запроса разрешений у ОС
  path_provider: ^2.1.4      # Для поиска путей к папкам устройства
```

#### Шаг 2: Настройка разрешений
Для корректной работы на мобильных ОС были внесены изменения в конфигурационные файлы.

**Android (AndroidManifest.xml):** Добавлены строки для доступа к камере и памяти:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

#### Шаг 3: Реализация логики (Код приложения)
В файле `main.dart` реализован основной экран приложения. Логика разделена на три части:
1.  **Проверка разрешений:** Использование `permission_handler` перед вызовом камеры.
2.  **Захват изображения:** Использование метода `picker.pickImage` с источниками `ImageSource.camera` или `ImageSource.gallery`.
3.  **Сохранение:** Копирование полученного временного файла в постоянную директорию приложения с помощью `path_provider`.

---

### 3. Ключевые фрагменты кода

**Метод выбора изображения:**
```dart
Future<void> _getImage(ImageSource source) async {
  await Permission.camera.request(); // Запрос разрешения
  final XFile? pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path); // Обновление UI
    });
  }
}
```

**Метод сохранения фото в память устройства:**
```dart
Future<void> _saveImage() async {
  if (_image == null) return;
  final dir = await getApplicationDocumentsDirectory(); // Путь к документам
  final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final File newFile = await _image!.copy('${dir.path}/$fileName');
  
  // Уведомление пользователя
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Сохранено в: ${newFile.path}')),
  );
}
```
**Трудности:**
Потребовалось время, чтобы разобраться в жизненном цикле объекта `XFile` при передаче его в стандартный класс `File` библиотеки `dart:io`.
---

### 4. Скриншоты

1.  **Интерфейс (главный экран):**
  
<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/740fb4fd-37b8-4391-b99a-af817297649d" />

2.  **Камера в действии:**
   
<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/51865b9b-9a2d-4143-806b-295a2b5897d4" />

3.  **Отображение выбранного фото:**
   
<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/eac24214-9d2a-4652-a61c-55b2f9fef308" />

---

### 5. Вывод (Заключение)

В ходе выполнения практической работы я изучил принципы взаимодействия Flutter-приложения с аппаратными модулями смартфона. 

**Что нового я узнал:**
*   Flutter не работает с железом напрямую, а использует плагины-обертки над нативными API (Android/iOS).
*   Для доступа к камере и памяти недостаточно просто написать код — нужно обязательно декларировать разрешения в манифестах ОС.
*   Работа с файловой системой требует понимания временных и постоянных путей хранения данных.
