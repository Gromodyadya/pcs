import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // Светлый фон
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/blob_background.png',
              width: size.width * 1,
              fit: BoxFit.cover,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.15),
                  
                  // ЗАГОЛОВОК
                  Text(
                    'Create\nAccount',
                    style: GoogleFonts.raleway(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 54 / 50,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 176), 
                  
                  _buildTextField(hint: 'Email'),
                  const SizedBox(height: 8),
                  _buildTextField(hint: 'Password', isPassword: true),
                  const SizedBox(height: 8),
                  _buildPhoneNumberField(),
                  
                  const SizedBox(height: 52),
                  
                  // КНОПКА DONE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: GoogleFonts.raleway( //Raleway для красоты
                          fontSize: 20, 
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Небольшой отступ снизу для скролла
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Raleway'),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Your number',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Raleway'),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/flag_ru.png',
                width: 24,
                height: 16,
              ),
              const SizedBox(width: 10),
              Container(height: 20, width: 1, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}