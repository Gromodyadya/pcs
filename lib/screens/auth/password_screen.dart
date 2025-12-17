import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. КАРТИНКА ФОНА (Слева сверху)
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Bubbles.png',
              width: size.width * 1,
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. КОНТЕНТ
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                // Выравнивание по центру по горизонтали
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  SizedBox(height: size.height * 0.34),
                  
                  // ЗАГОЛОВОК Hello!
                  Text(
                    'Hello!',
                    style: GoogleFonts.raleway(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Text(
                    'Type your password',
                    style: GoogleFonts.raleway(
                      fontSize: 19, 
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Большой отступ перед полем ввода
                  const SizedBox(height: 126),
                  
                  _buildPasswordField(),
                  
                  const SizedBox(height: 83), // Отступ перед кнопкой
                  
                  // КНОПКА START
                  SizedBox(
                    width: double.infinity,
                    height: 61, // Делаем кнопку высокой
                    child: ElevatedButton(
                      onPressed: () {
                        // Переход в главное приложение
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Квадратнее
                        ),
                      ),
                      child: Text(
                        'Start',
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
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Назад на Логин
                    },
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.grey.shade400, 
          fontFamily: 'Raleway'
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8), // Светло-серый
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Круглые края (таблетка)
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16, // Высокое поле
          horizontal: 24,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}