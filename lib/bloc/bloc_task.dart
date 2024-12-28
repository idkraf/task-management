import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity
import 'package:hive/hive.dart';
import '../model/standard_list_model.dart';
import '../model/task_model.dart';
import '../provider/repository.dart';
import '../service/task_reminder_service.dart';

class BlocTask {
  final _repository = Repository();
  final _taskBox = Hive.box<TaskModel>('tasks');
  final _reminderService = TaskReminderService();

  final _taskController = StreamController<List<TaskModel>>.broadcast();
  Stream<List<TaskModel>> get taskStream => _taskController.stream;

  BlocTask() {
    _reminderService.initializeNotifications();
    _loadTasks();
  }

  void createTask(TaskModel task) {
    _taskBox.add(task);
    _scheduleReminderForTask(task); // Schedule reminder
    _syncDataWithServer(); // Optional: Sync with server if online
    _loadTasks(); // Reload tasks from Hive
  }

  void updateTask(TaskModel task) {
    task.save();
    // If the task status is pending, schedule a reminder
    if (task.status == TaskStatus.pending) {
      _scheduleReminderForTask(task);
    } else {
      _reminderService.cancelReminder(task.key); // Cancel reminder if status is not pending
    }

    _syncDataWithServer(); // Sync data with the server
    _loadTasks(); // Reload tasks from Hive
  }

  void deleteTask(TaskModel task) {
    _reminderService.cancelReminder(task.key); // Cancel associated reminder
    task.delete();
    _syncDataWithServer();
    _loadTasks();
  }

  void _loadTasks() {
    var tasks = _taskBox.values.toList();
    _taskController.sink.add(tasks);
  }

  void _scheduleReminderForTask(TaskModel task) {
    if (task.status == TaskStatus.pending && task.dueDate.isAfter(DateTime.now())) {
      _reminderService.scheduleTaskReminder(
        task.key, // Unique ID for each task
        'Task Reminder',
        'Don\'t forget: ${task.title}',
        task.dueDate,
      );
    }
  }

  Future<void> _syncDataWithServer() async {
    // Check if there are tasks in the Hive box
    if (_taskBox.isEmpty) {
      return; // No tasks to sync
    }

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("No internet connection. Tasks will not be synced.");
      return; // No internet connection, skip sync
    }

    // Convert tasks into a list of maps
    List<Map<String, dynamic>> taskList = _taskBox.values.map((task) {
      return {
        'id': task.key, // Unique identifier for the task
        'title': task.title,
        'description': task.description,
        'due_date': task.dueDate.toIso8601String(),
        'status': task.status.name, // Assuming `status` is an enum
      };
    }).toList();

    // Prepare the body for the API request
    final Map<String, dynamic> body = {
      'tasks': taskList,
    };

    try {
      // Send the task data to the server using the repository
      StandardListModels response = await _repository.syncTask(body: body);

      if (response.data != null) {
        print("Tasks successfully synced with server");
        // Handle server response, e.g., updating task status if needed
      } else {
        print("Failed to sync tasks with server");
      }
    } catch (e) {
      print("Error during task sync: $e");
    }
  }

  void close() {
    _taskController.close();
  }

  dispose() {
    _taskController.close();
  }
}

final bloc = BlocTask();
