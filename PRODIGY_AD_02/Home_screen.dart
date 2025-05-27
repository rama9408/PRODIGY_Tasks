import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final loadedTasks = await storage.readTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  void _saveTasks() {
    storage.writeTasks(tasks);
  }

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
    _saveTasks();
  }

  void _editTask(int index, String newTitle) {
    setState(() {
      tasks[index].title = newTitle;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _toggleDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    _saveTasks();
  }

  void _showTaskDialog({int? index}) {
    final controller = TextEditingController(
        text: index != null ? tasks[index].title : '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index != null ? 'Edit Task' : 'New Task'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                index == null ? _addTask(text) : _editTask(index, text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('To-Do List')),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              tasks[index].title,
              style: TextStyle(
                  decoration: tasks[index].isDone
                      ? TextDecoration.lineThrough
                      : null),
            ),
            leading: Checkbox(
              value: tasks[index].isDone,
              onChanged: (_) => _toggleDone(index),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showTaskDialog(index: index)),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(index)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showTaskDialog(),
          child: const Icon(Icons.add),
        ),
      );
}
