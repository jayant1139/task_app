import 'package:hive_flutter/hive_flutter.dart';

class taskDatabase {
  List tasksList = [];

  //referencing our box
  final _mybox = Hive.box('tasks');

  void loadtasks() {
    tasksList = _mybox.get("key");
  }

  void updateDatabase() {
    _mybox.put("key", tasksList);
  }
}
