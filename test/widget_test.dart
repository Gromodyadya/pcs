import 'package:flutter_test/flutter_test.dart';
import 'package:optimization_lab/main.dart'; // Убедись, что имя пакета совпадает с твоим pubspec.yaml

void main() {
  // 1. UNIT TEST (Тест логики)
  // Проверяем, что Dart правильно генерирует списки
  test('List generation logic test', () {
    final list = List.generate(5, (index) => "Item $index");
    
    expect(list.length, 5);
    expect(list.first, "Item 0");
    expect(list.last, "Item 4");
  });

  // 2. WIDGET TEST (Тест интерфейса)
  // Проверяем, что наше приложение рисуется правильно
  testWidgets('App renders list and buttons', (WidgetTester tester) async {
    // Загружаем наше приложение (MyApp)
    await tester.pumpWidget(const MyApp());

    // Ждем, пока Flutter всё отрисует
    await tester.pump();

    // ПРОВЕРКИ:
    
    // 1. Ищем заголовок AppBar
    expect(find.text('Тормознутый список'), findsOneWidget);

    // 2. Ищем кнопку "Сломать приложение"
    expect(find.text('Сломать приложение'), findsOneWidget);

    // 3. Ищем первый элемент списка "Item 0"
    expect(find.text('Item 0'), findsOneWidget);
  });
}