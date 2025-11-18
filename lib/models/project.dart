// lib/models/project.dart
import 'dart:convert';

class Project {
  String id;
  String title;
  String description;
  List<String> tags;
  DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.createdAt,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) =>
      Project.fromMap(json.decode(source));
}
