import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  Future<List<Task>> readTasks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final jsonList = json.decode(contents) as List;
      return jsonList.map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> writeTasks(List<Task> tasks) async {
    final file = await _localFile;
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }
}
