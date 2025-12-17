import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height, // Принудительно на всю высоту экрана
            child: Image.asset(
              'assets/images/blob_top_left.png', 
              // fill растянет картинку до самого низа, даже если пропорции не совпадают
              fit: BoxFit.fill, 
            ),
          ),
          
          // 2. ОСНОВНОЙ КОНТЕНТ
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Большой отступ сверху, чтобы текст был ниже картинки
                  SizedBox(height: size.height * 0.55), 
                  
                  // ЗАГОЛОВОК
                  Text(
                    'Login',
                    style: GoogleFonts.raleway(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // ПОДЗАГОЛОВОК С СЕРДЕЧКОМ
                  Row(
                    children: [
                      Text(
                        'Good to see you back!',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7), // Чуть серый
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.favorite, color: Colors.black, size: 20),
                    ],
                  ),
                  
                  const SizedBox(height: 17),
                  
                  // ПОЛЕ EMAIL
                  _buildTextField(hint: 'Email'),
                  
                  
                  const SizedBox(height: 37),
                  
                  // КНОПКА LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 61,
                    child: ElevatedButton(
                      onPressed: () {
                        // Переход на экран пароля
                        Navigator.pushNamed(context, '/password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Радиус
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.raleway(
                          fontSize: 22, 
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 14),
                  
                  // КНОПКА CANCEL
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Логика отмены
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // МЕТОД ДЛЯ ПОЛЕЙ ВВОДА
  Widget _buildTextField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400, 
          fontFamily: 'Raleway'
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8), // Светло-серый фон
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Овальная форма (таблетка)
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
      ),
    );
  }
}