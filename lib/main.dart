import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  // ШАГ 7: Глобальный перехват ошибок (Zone)
  // Это ловит ошибки, которые случаются в асинхронном коде
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    // Сюда можно подключить отправку логов на сервер (Sentry/Firebase)
    debugPrint("ГЛОБАЛЬНАЯ ОШИБКА ПЕРЕХВАЧЕНА: $error");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 14 Optimized',
      theme: ThemeData(primarySwatch: Colors.green),
      // ШАГ 7: Настройка пользовательского экрана ошибки
      // Вместо "Красного экрана смерти" показываем дружелюбный дизайн
      builder: (context, widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    "Ой! Произошла ошибка :(",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Мы уже работаем над исправлением."),
                ],
              ),
            ),
          );
        };
        return widget!;
      },
      home: const OptimizedListPage(),
    );
  }
}

class OptimizedListPage extends StatefulWidget {
  const OptimizedListPage({super.key});

  @override
  State<OptimizedListPage> createState() => _OptimizedListPageState();
}

class _OptimizedListPageState extends State<OptimizedListPage> {
  // Генерация данных (1000 элементов)
  final List<String> items = List.generate(1000, (index) => "Optimized Item $index");

  // Флаг для имитации критической ошибки в build()
  bool shouldCrash = false;

  @override
  Widget build(BuildContext context) {
    // ЛОГИКА ДЛЯ ТЕСТА ОШИБКИ:
    // Если нажали кнопку, выбрасываем ошибку прямо при отрисовке.
    // Это заставит Flutter показать наш ErrorWidget.
    if (shouldCrash) {
      throw Exception("Тестовая критическая ошибка для лабораторной!");
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Быстрый список (Optimized)")),
      body: Column(
        children: [
          Expanded(
            // ОПТИМИЗАЦИЯ 1: ListView.builder (Ленивая загрузка)
            // Создает виджеты только для тех элементов, которые видны на экране
            child: ListView.builder(
              itemCount: items.length,
              // ОПТИМИЗАЦИЯ 2: itemExtent (Фиксированная высота)
              // Помогает Flutter не пересчитывать высоту каждого элемента
              itemExtent: 80,
              itemBuilder: (context, index) {
                // ОПТИМИЗАЦИЯ 3: Вынос элементов в отдельный виджет
                return ItemWidget(
                  // ОПТИМИЗАЦИЯ 4: Использование ключей (Keys)
                  key: ValueKey(index),
                  text: items[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                // Меняем состояние, чтобы вызвать перерисовку с ошибкой
                setState(() {
                  shouldCrash = true;
                });
              },
              icon: const Icon(Icons.bug_report),
              label: const Text("Вызвать экран ошибки"),
            ),
          ),
        ],
      ),
    );
  }
}

// ОПТИМИЗАЦИЯ 3: Отдельный класс виджета
class ItemWidget extends StatelessWidget {
  final String text;

  // ОПТИМИЗАЦИЯ 5: Использование const конструктора
  // Позволяет Flutter переиспользовать этот виджет, если данные не менялись
  const ItemWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green, size: 40),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("Статичный текст (без вычислений)"),
      ),
    );
  }
}