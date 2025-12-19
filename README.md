# Отчет по практическому занятию № 13
**Тема:** Аппаратная часть мобильных устройств. Работа с геолокацией. Работа с различными датчиками устройства.

## 1. Цель работы
Изучить возможности работы с аппаратными датчиками и сервисами мобильного устройства на платформе Flutter. Освоить методы получения географических координат (геолокация), преобразования их в адрес (геокодинг), а также научиться получать и обрабатывать данные с сенсоров: акселерометра, гироскопа и компаса.

## 2. Ход выполнения

### 2.1. Подготовка проекта и установка зависимостей
Был создан новый проект Flutter `geo_sensors_app`. В файл `pubspec.yaml` были добавлены следующие пакеты для работы с нативным API устройства:

*   **geolocator:** для получения текущих координат (широта, долгота) и проверки статуса служб геолокации.
*   **geocoding:** для преобразования координат в человекочитаемый адрес (Reverse Geocoding).
*   **sensors_plus:** для доступа к данным акселерометра и гироскопа.
*   **flutter_compass:** для получения данных о направлении устройства (магнитный азимут).

### 2.2. Настройка разрешений
Для корректной работы приложения в файл `AndroidManifest.xml` (для Android) были добавлены разрешения на использование геолокации:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET"/>
```

### 2.3. Реализация логики приложения (Основные фрагменты кода)

**Получение геолокации и адреса:**
Использован асинхронный метод для запроса прав доступа и получения позиции.

```dart
Future<void> _getLocation() async {
  // Проверка включена ли служба
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return;

  // Запрос разрешений
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
  }

  // Получение координат
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Геокодинг (получение адреса)
  List<Placemark> placemarks = await placemarkFromCoordinates(
      pos.latitude, pos.longitude);
      
  setState(() {
    _position = pos;
    _address = '${placemarks.first.locality}, ${placemarks.first.street}';
  });
}
```

**Работа с сенсорами (Stream):**
Данные с сенсоров поступают в реальном времени через потоки (`Stream`). Мы подписываемся на события в методе `initState`.

```dart
@override
void initState() {
  super.initState();
  // Подписка на акселерометр
  accelerometerEvents.listen((event) {
    setState(() => _accelerometerValues = [event.x, event.y, event.z]);
  });

  // Подписка на гироскоп
  gyroscopeEvents.listen((event) {
    setState(() => _gyroscopeValues = [event.x, event.y, event.z]);
  });

  // Подписка на компас
  FlutterCompass.events?.listen((event) {
    setState(() => _compass = event.heading);
  });
}
```

## 3. Результаты и скриншоты

Разработано приложение «Geo & Sensors App». При запуске на реальном устройстве приложение успешно выполняет все поставленные задачи.

**3.1. Отображение координат и адреса**
При нажатии кнопки «Определить местоположение» приложение запрашивает разрешение, получает координаты GPS и преобразует их в адрес улицы.

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/667f98a4-62de-4888-adac-7da08a79d60a" />

**3.2. Реакция сенсоров**
В нижней части экрана отображаются значения осей X, Y, Z для акселерометра и гироскопа. При вращении и наклоне телефона цифры меняются в реальном времени.

<img width="575" height="1280" alt="image" src="https://github.com/user-attachments/assets/5ab0628c-165a-429d-9b8d-47c2cb4c369f" />

## 4. Вывод

В ходе выполнения практической работы были изучены методы взаимодействия с аппаратной частью мобильного устройства с использованием фреймворка Flutter.

**Основные результаты:**
1.  Освоена работа с пакетом `geolocator`: реализован запрос разрешений (`Runtime Permissions`) и получение точных координат устройства.
2.  Изучен принцип обратного геокодинга с помощью пакета `geocoding`, позволяющий получать читаемый адрес по координатам.
3.  Реализована работа с потоками данных (`Streams`) от аппаратных датчиков (акселерометр, гироскоп, компас).
4.  Выявлено, что работа с сенсорами требует обработки жизненного цикла виджетов (подписка при инициализации и отписка при закрытии) для экономии ресурсов батареи.

Работа показывает, что Flutter предоставляет удобный доступ к нативным функциям устройства через систему плагинов, что позволяет создавать функциональные приложения, взаимодействующие с физическим окружением пользователя.
