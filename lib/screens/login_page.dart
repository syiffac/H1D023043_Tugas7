// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final storage = await StorageService.getInstance();

    // Simple/dummy auth: accept any username/password length >= 3
    await Future.delayed(Duration(milliseconds: 400));

    final profile = {
      'id': Uuid().v4(),
      'name': _usernameC.text.trim(),
      'email': '${_usernameC.text.trim()}@example.com',
    };
    await storage.setUserProfile(profile);
    await storage.setLoggedIn(true);

    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _usernameC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - NIM_Tugas7')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameC,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Min 3 chars'
                        : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordC,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Min 3 chars'
                        : null,
                  ),
                  SizedBox(height: 20),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _login,
                          icon: Icon(Icons.login),
                          label: Text('Login'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
