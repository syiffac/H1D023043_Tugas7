// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/project.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StorageService storage;
  List<Project> projects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    storage = await StorageService.getInstance();
    projects = storage.getProjects();
    setState(() => loading = false);
  }

  Future<void> _refresh() async {
    projects = storage.getProjects();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Portfolio')),
      drawer: AppDrawer(storage: storage),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : projects.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No projects yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text('Tap the + button to add your first project.'),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/project/add',
                      ).then((_) => _refresh()),
                      icon: Icon(Icons.add),
                      label: Text('Add Project'),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (ctx, i) {
                  final p = projects[i];
                  return ListTile(
                    title: Text(p.title),
                    subtitle: Text(p.tags.join(' • ')),
                    trailing: Text(
                      '${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}',
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/project/detail',
                      arguments: p,
                    ).then((_) => _refresh()),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/project/add',
        ).then((_) => _refresh()),
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}
