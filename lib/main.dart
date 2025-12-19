import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notes_page.dart'; // Импортируем второй файл

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: ВСТАВЬ СВОИ ДАННЫЕ ТУТ
  await Supabase.initialize(
    url: 'секрет',
    anonKey: 'секрет',
  );

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Этот виджет автоматически переключает экраны при входе/выходе
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;
        if (session != null) {
          return const NotesPage(); // Если вошли — показываем заметки
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Вход / Регистрация')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password (минимум 6 симв.)', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                if (_isLoading)
                  const CircularProgressIndicator()
                else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signIn,
                      child: const Text('Войти'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _signUp,
                      child: const Text('Зарегистрироваться'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // Логика входа
  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Произошла ошибка');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Логика регистрации
  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Успешно! Если включено подтверждение, проверьте почту.')),
        );
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Произошла ошибка');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}