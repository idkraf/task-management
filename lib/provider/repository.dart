import '../model/task_model.dart';
import 'api_provider.dart';
import 'package:task_management/model/standard_list_model.dart';

class Repository {

  final apiProvider = ApiProvider();

  Future<StandardListModels> actLogin({Map<String, dynamic>? body}) =>
      apiProvider.actLogin(body: body);

  Future<StandardListModels> fetchTasks({required int page}) =>
      apiProvider.actTask(page: page);

  Future<StandardListModels> syncTask({Map<String, dynamic>? body}) =>
      apiProvider.syncTask(body: body);
}