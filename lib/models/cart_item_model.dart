import 'product_model.dart';

class CartItem {
  final Product product;
  final String details; // "Pink, Size M"
  int quantity;

  CartItem({
    required this.product,
    required this.details,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}