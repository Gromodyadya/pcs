import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ShopScreen extends StatelessWidget {
  ShopScreen({Key? key}) : super(key: key);

  // ЗАМЕНИТЕ ПУТИ НА ВАШИ КАРТИНКИ В assets/images/
  final List<Product> _products = [
    Product(
      imagePath: 'assets/images/product1.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
    Product(
      imagePath: 'assets/images/product2.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
    Product(
      imagePath: 'assets/images/product3.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
    Product(
      imagePath: 'assets/images/product4.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
    Product(
      imagePath: 'assets/images/product5.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
    Product(
      imagePath: 'assets/images/product6.png',
      name: 'Lorem ipsum dolor sit amet consectetur',
      price: 17.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GridView.builder(
                itemCount: _products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  return _buildProductCard(_products[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Shop',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Chip(
            label: const Text(
              'Clothing',
              style: TextStyle(color: Color(0xFF0052FF)),
            ),
            backgroundColor: const Color(0xFF0052FF).withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // ЗАМЕНИТЕ ЭТО НА Image.asset(product.imagePath), КОГДА ДОБАВИТЕ КАРТИНКИ
                  color: Colors.grey.shade200,
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite_border, color: Colors.red),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
