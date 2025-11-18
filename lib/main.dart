// lib/main.dart
import 'package:flutter/material.dart';
import 'routes.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.getInstance();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final StorageService storage;
  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NIM_Tugas7 - Portfolio',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: false),
      initialRoute: storage.isLoggedIn() ? '/home' : '/',
      onGenerateRoute: Routes.generate,
    );
  }
}
