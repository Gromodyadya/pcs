// lib/models/product_model.dart

class Product {
  final String imagePath;
  final String name;
  final double price;
  bool isFavourite; // Эта строчка у нас уже была

  Product({
    required this.imagePath,
    required this.name,
    required this.price,
    this.isFavourite = false, // <-- ВОТ ЭТУ СТРОЧКУ НУЖНО ДОБАВИТЬ
  });
}
