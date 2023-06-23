import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:task_app/pages/create_task.dart';

void saveTasks(tasks) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> tasksJson = tasks.map((task) => task.toJson()).toList();
  String tasksString = json.encode(tasksJson);
  await prefs.setString('tasks', tasksString);
  print("Function saveTasks() executed");
}
