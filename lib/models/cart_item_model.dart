class CartItem {
  final String imagePath;
  final String name;
  final String details; // Например, "Pink, Size M"
  final double price;
  int quantity;

  CartItem({
    required this.imagePath,
    required this.name,
    required this.details,
    required this.price,
    this.quantity = 1,
  });
}
