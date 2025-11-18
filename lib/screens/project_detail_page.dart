// lib/screens/project_detail_page.dart
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/storage_service.dart';
import 'add_project_page.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;
  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late StorageService _storage;

  @override
  void initState() {
    super.initState();
    StorageService.getInstance().then((s) => _storage = s);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete project?'),
        content: Text(
          'Are you sure you want to delete "${widget.project.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _storage.deleteProject(widget.project.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddProjectPage(project: p)),
            ).then((_) => Navigator.pop(context)), // pop detail after edit
          ),
          IconButton(icon: Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(
              'Created: ${p.createdAt.toLocal().toString().split(' ').first}',
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: p.tags.map((t) => Chip(label: Text(t))).toList(),
            ),
            SizedBox(height: 16),
            Text(p.description),
          ],
        ),
      ),
    );
  }
}
