class Product {
  final String id; // Уникальный ID, чтобы точно знать какой товар
  final String imagePath;
  final String name;
  final double price;
  bool isFavourite;

  Product({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    this.isFavourite = false,
  });
}