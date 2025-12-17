import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import 'shop/cart_screen.dart';
import 'shop/favourites_screen.dart';
import 'shop/shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Данные (товары)
  final List<Product> _allProducts = [
    Product(id: '1', imagePath: 'assets/images/product1.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
    Product(id: '2', imagePath: 'assets/images/product2.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
    Product(id: '3', imagePath: 'assets/images/product3.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
    Product(id: '4', imagePath: 'assets/images/product4.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
    Product(id: '5', imagePath: 'assets/images/product5.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
    Product(id: '6', imagePath: 'assets/images/product6.png', name: 'Lorem ipsum dolor sit amet', price: 17.00),
  ];

  final List<CartItem> _cartItems = [];

  // Логика избранного
  void _toggleFavorite(Product product) {
    setState(() {
      product.isFavourite = !product.isFavourite;
    });
  }

  // Логика корзины
  void _toggleCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    setState(() {
      if (existingIndex != -1) {
        _cartItems.removeAt(existingIndex);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} removed from cart'), duration: const Duration(milliseconds: 500)),
        );
      } else {
        _cartItems.add(CartItem(product: product, details: 'Pink, Size M'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(milliseconds: 500)),
        );
      }
    });
  }

  void _removeFromCart(CartItem item) {
    setState(() => _cartItems.remove(item));
  }

  void _updateCartQuantity(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) _cartItems.remove(item);
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // --- ВСПОМОГАТЕЛЬНЫЙ ВИДЖЕТ ДЛЯ АКТИВНОЙ ИКОНКИ ---
  Widget _buildActiveIcon(String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Занимаем минимум места
      children: [
        Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ShopScreen(
            products: _allProducts,
            cartItems: _cartItems,
            onToggleFavorite: _toggleFavorite,
            onToggleCart: _toggleCart,
          ),
          FavouritesScreen(
            favouriteProducts: _allProducts.where((p) => p.isFavourite).toList(),
            onToggleFavorite: _toggleFavorite,
            onAddToCart: _toggleCart,
          ),
          CartScreen(
            cartItems: _cartItems,
            onRemove: _removeFromCart,
            onUpdateQuantity: _updateCartQuantity,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        // Добавляем верхнюю границу (тень)
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          
          items: [
            // --- HOME ---
            BottomNavigationBarItem(
              // Обычное состояние
              icon: Image.asset('assets/images/nav_home.png', width: 24, height: 24),
              // Активное состояние
              activeIcon: _buildActiveIcon('assets/images/nav_home_active.png'),
              label: '',
            ),
            
            // --- FAVOURITES ---
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/nav_heart.png', width: 24, height: 24),
              activeIcon: _buildActiveIcon('assets/images/nav_heart_active.png'),
              label: '',
            ),
            
            // --- CART ---
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/nav_bag.png', width: 24, height: 24),
              activeIcon: _buildActiveIcon('assets/images/nav_bag_active.png'),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}