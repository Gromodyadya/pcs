import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onRemove;
  final Function(CartItem, int) onUpdateQuantity;

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.onRemove,
    required this.onUpdateQuantity,
  }) : super(key: key);

  double _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(cartItems[index]);
              },
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          Text(
            'Cart',
            style: GoogleFonts.raleway(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          // Кружок с количеством
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Светло-голубой
              shape: BoxShape.circle,
            ),
            child: Text(
              cartItems.length.toString(),
              style: GoogleFonts.raleway(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // КАРТИНКА + МУСОРКА
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.product.imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              // Иконка мусорки
              Positioned(
                bottom: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () => onRemove(item),
                  child: Image.asset(
                    'assets/images/icon_trash.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // ТЕКСТ И КНОПКИ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: GoogleFonts.raleway(color: Colors.black, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.details,
                  style: GoogleFonts.raleway(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    
                    // КНОПКИ +/-
                    Row(
                      children: [
                        _quantityButton(Icons.remove, () => onUpdateQuantity(item, -1)),
                        Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: Text(
                            item.quantity.toString(),
                            style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        _quantityButton(Icons.add, () => onUpdateQuantity(item, 1)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0052FF), width: 1.5), // Синяя обводка
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF0052FF)),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      color: const Color(0xFFF9F9F9), // Светло-серый фон футера
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Total ',
                style: GoogleFonts.raleway(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculateTotal().toStringAsFixed(2).replaceAll('.', ',')}',
                style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052FF),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Checkout',
              style: GoogleFonts.raleway(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}