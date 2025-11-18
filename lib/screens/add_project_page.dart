// lib/screens/add_project_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../services/storage_service.dart';

class AddProjectPage extends StatefulWidget {
  final Project? project; // if null -> create; else edit
  const AddProjectPage({super.key, this.project});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _tagsC = TextEditingController();
  bool _saving = false;
  late StorageService _storage;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _titleC.text = widget.project!.title;
      _descC.text = widget.project!.description;
      _tagsC.text = widget.project!.tags.join(', ');
    }
    StorageService.getInstance().then((s) => _storage = s);
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _tagsC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final tags = _tagsC.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (widget.project == null) {
      final p = Project(
        id: Uuid().v4(),
        title: _titleC.text.trim(),
        description: _descC.text.trim(),
        tags: tags,
        createdAt: DateTime.now(),
      );
      await _storage.addProject(p);
    } else {
      final updated = Project(
        id: widget.project!.id,
        title: _titleC.text.trim(),
        description: _descC.text.trim(),
        tags: tags,
        createdAt: widget.project!.createdAt,
      );
      await _storage.updateProject(updated);
    }

    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Project' : 'Add Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _titleC,
                    decoration: InputDecoration(labelText: 'Project Title'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter title' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descC,
                    decoration: InputDecoration(labelText: 'Short Description'),
                    minLines: 3,
                    maxLines: 5,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Enter description'
                        : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _tagsC,
                    decoration: InputDecoration(
                      labelText: 'Tags (comma separated)',
                    ),
                  ),
                  SizedBox(height: 18),
                  _saving
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                          onPressed: _save,
                          icon: Icon(Icons.save),
                          label: Text(isEdit ? 'Save Changes' : 'Add Project'),
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
