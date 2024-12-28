// lib/models/task_model.dart
import 'package:hive/hive.dart';

part 'task_model.g.dart'; // Generate the adapter file

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  TaskStatus status;

  TaskModel({
    required this.title,
    required this.dueDate,
    this.description = '',
    this.status = TaskStatus.pending,
  });
}

@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed
}
