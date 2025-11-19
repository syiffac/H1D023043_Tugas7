// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class StorageService {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserProfile = 'user_profile';
  static const _keyProjects = 'projects_list';
  static const _keyRegisteredUser = 'registered_user';

  final SharedPreferences _prefs;
  StorageService._(this._prefs);

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  // Auth
  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) async =>
      _prefs.setBool(_keyIsLoggedIn, value);

  // Check if user is registered
  bool hasRegisteredUser() {
    return _prefs.getString(_keyRegisteredUser) != null;
  }

  // Register new user (hanya bisa 1 kali)
  Future<bool> registerUser(String username, String password) async {
    if (hasRegisteredUser()) {
      return false; // Sudah ada user terdaftar
    }
    final userData = {
      'username': username.trim(),
      'password': password, // Di production, gunakan hashing!
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(_keyRegisteredUser, json.encode(userData));
    return true;
  }

  // Validate login
  bool validateLogin(String username, String password) {
    final userStr = _prefs.getString(_keyRegisteredUser);
    if (userStr == null) return false;

    final userData = json.decode(userStr) as Map<String, dynamic>;
    return userData['username'] == username.trim() &&
        userData['password'] == password;
  }

  // Get registered username
  String? getRegisteredUsername() {
    final userStr = _prefs.getString(_keyRegisteredUser);
    if (userStr == null) return null;
    final userData = json.decode(userStr) as Map<String, dynamic>;
    return userData['username'] as String;
  }

  Map<String, dynamic>? getUserProfile() {
    final jsonStr = _prefs.getString(_keyUserProfile);
    if (jsonStr == null) return null;
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  Future<void> setUserProfile(Map<String, dynamic> profile) =>
      _prefs.setString(_keyUserProfile, json.encode(profile));

  Future<void> clearUserProfile() async {
    await _prefs.remove(_keyUserProfile);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  // Delete account (menghapus semua data user)
  Future<void> deleteAccount() async {
    await _prefs.remove(_keyRegisteredUser);
    await _prefs.remove(_keyUserProfile);
    await _prefs.remove(_keyProjects);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }

  // Projects
  List<Project> getProjects() {
    final jsonStr = _prefs.getString(_keyProjects);
    if (jsonStr == null) return [];
    final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
    return list.map((e) => Project.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveProjects(List<Project> projects) async {
    final list = projects.map((p) => p.toMap()).toList();
    await _prefs.setString(_keyProjects, json.encode(list));
  }

  Future<void> addProject(Project project) async {
    final projects = getProjects();
    projects.insert(0, project);
    await saveProjects(projects);
  }

  Future<void> updateProject(Project updated) async {
    final projects = getProjects();
    final idx = projects.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      projects[idx] = updated;
      await saveProjects(projects);
    }
  }

  Future<void> deleteProject(String id) async {
    final projects = getProjects();
    projects.removeWhere((p) => p.id == id);
    await saveProjects(projects);
  }
}
