import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';
import 'package:task_management/model/standard_list_model.dart';
import 'package:task_management/provider/repository.dart';

class TaskBloc {
  final _repository = Repository();

  final _getTask = PublishSubject<StandardListModels>();
  final List<Map<String, dynamic>> _allTasks = []; // Store all tasks across pages

  Stream<StandardListModels> get getMyTask => _getTask.stream;

  // Fetch tasks from either online or offline
  fetchTasks(int page, void Function(StandardListModels models) callback) async {
    Box<StandardListModels> taskBox = await Hive.openBox<StandardListModels>('taskBox');
    StandardListModels model;

    // Try fetching from Hive first (offline support)
    var cachedData = taskBox.get('page_$page');
    if (cachedData != null) {
      _appendAndEmitData(cachedData, callback);
      return; // Don't continue if we have cached data
    }

    // Fetch data from repository (online support)
    model = await _repository.fetchTasks(page: page);
    if (model.data != null) {
      // Save the fetched data to Hive for offline usage
      taskBox.put('page_$page', model);
    }

    // Append and emit the newly fetched data
    _appendAndEmitData(model, callback);
  }

  // Append new data and emit combined tasks
  void _appendAndEmitData(StandardListModels model, void Function(StandardListModels models) callback) {
    if (model.data != null) {
      _allTasks.addAll(model.data!); // Append new tasks to the list
    }

    // Create a combined model
    final combinedModel = StandardListModels(
      model.page,
      model.per_page,
      _allTasks.length,
      (model.total_pages ?? 1),
      List<Map<String, dynamic>>.from(_allTasks), // Create a fresh copy of all tasks
    );

    // Emit combined data
    _getTask.sink.add(combinedModel);
    callback(combinedModel);
  }

  dispose() {
    _getTask.close();
  }
}

final bloc = TaskBloc();

