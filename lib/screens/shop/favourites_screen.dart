import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Product> favouriteProducts;
  final Function(Product) onToggleFavorite;
  final Function(Product) onAddToCart; 

  const FavouritesScreen({
    Key? key,
    required this.favouriteProducts,
    required this.onToggleFavorite,
    required this.onAddToCart, // Принимаем, чтобы не ломать main.dart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Text(
              'Favourites',
              style: GoogleFonts.raleway(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: favouriteProducts.isEmpty
                ? Center(
                    child: Text("No favourites yet",
                        style: GoogleFonts.raleway(fontSize: 16, color: Colors.grey)))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16, top: 10),
                      itemCount: favouriteProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,  // Как в Shop
                        mainAxisSpacing: 12,   // Как в Shop
                        childAspectRatio: 0.62, // Как в Shop
                      ),
                      itemBuilder: (context, index) {
                        return _buildProductCard(favouriteProducts[index]);
                      },
                    ),
                  ),
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
              // 1. ФОН И КАРТИНКА
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.0), // Тень как в Shop
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
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // 2. СЕРДЦЕ
              Positioned(
                top: 15,
                left: 12,
                child: GestureDetector(
                  onTap: () => onToggleFavorite(product),
                  child: Image.asset(
                    'assets/images/icon_heart_red.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // ТЕКСТ
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            product.name,
            style: GoogleFonts.raleway(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
            style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }
}