// lib/screens/settings_page.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late StorageService _storage;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    StorageService.getInstance().then((s) {
      _storage = s;
      profile = _storage.getUserProfile();
      setState(() {});
    });
  }

  Future<void> _logout() async {
    await _storage.clearUserProfile();
    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? '';
    final email = profile?['email'] ?? '';
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(name),
              subtitle: Text(email),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
