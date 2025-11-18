// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/add_project_page.dart';
import 'screens/project_detail_page.dart';
import 'screens/settings_page.dart';
import 'models/project.dart'; // Tambahkan import ini

class Routes {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/project/add':
        return MaterialPageRoute(builder: (_) => AddProjectPage());
      case '/project/detail':
        return MaterialPageRoute(
          builder: (_) => ProjectDetailPage(
            project: args as Project,
          ), // Tambahkan 'as Project'
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
