import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart';

/*
Data That a task will hold
Task Title
Task Content
Task last save time
task is check or unchecked
task radio color
 */

@HiveType(typeId: 2)
class Task {
  Task(
      {required this.taskContent,
      required this.lastSaveTime,
      required this.isChecked,
      required this.colorMap});

  @HiveField(6)
  String taskContent;

  @HiveField(7)
  String lastSaveTime;

  @HiveField(8)
  bool isChecked;

  @HiveField(9)
  List<int> colorMap;
}
