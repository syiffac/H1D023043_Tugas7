// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppDrawer extends StatelessWidget {
  final StorageService storage;
  const AppDrawer({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final profile = storage.getUserProfile();
    final name = profile?['name'] ?? 'User';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(profile?['email'] ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(name.isNotEmpty ? name[0] : 'U'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('Add Project'),
            onTap: () => Navigator.pushNamed(context, '/project/add'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await storage.clearUserProfile();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
