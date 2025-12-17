import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';

class ShopScreen extends StatelessWidget {
  final List<Product> products;
  final List<CartItem> cartItems; // Нужно для проверки, в корзине ли товар
  final Function(Product) onToggleFavorite;
  final Function(Product) onToggleCart; // Функция переключения

  const ShopScreen({
    Key? key,
    required this.products,
    required this.cartItems,
    required this.onToggleFavorite,
    required this.onToggleCart,
  }) : super(key: key);

  // Проверка: есть ли товар в корзине?
  bool _isInCart(Product product) {
    return cartItems.any((item) => item.product.id == product.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16, top: 10), // Чуть отступа сверху для теней
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62, // Пропорция карточки
                ),
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Shop',
            style: GoogleFonts.raleway(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          // ВЫТЯНУТЫЙ ОВАЛ CLOTHING
          Container(
            width: 280,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0052FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              'Clothing',
              style: GoogleFonts.raleway(
                color: const Color(0xFF0052FF),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final bool inCart = _isInCart(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded задает высоту карточки
        Expanded(
          child: Stack(
            children: [
              // 1. ФОН И КАРТИНКА 
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.0),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover, // Растягиваем и обрезаем
                    ),
                  ),
                ),
              ),

              // СЕРДЦЕ
              Positioned(
                top: 15,
                left: 12,
                child: GestureDetector(
                  onTap: () => onToggleFavorite(product),
                  child: Image.asset(
                    product.isFavourite
                        ? 'assets/images/icon_heart_red.png'
                        : 'assets/images/icon_heart_white.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),

              // КОРЗИНА
              Positioned(
                bottom: 30,
                left: 12,
                child: GestureDetector(
                  onTap: () => onToggleCart(product),
                  child: Image.asset(
                    inCart
                        ? 'assets/images/icon_bag_filled.png' // Картинка для "В корзине"
                        : 'assets/images/icon_bag.png',       // Обычная картинка
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            product.name,
            style: GoogleFonts.raleway(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }
}