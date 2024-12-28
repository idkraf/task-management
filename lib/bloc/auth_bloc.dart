import 'dart:convert';
import 'package:task_management/utility/sharedpreferences_helper.dart';

import 'package:task_management/model/standard_list_model.dart';
import 'package:task_management/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final _repository = Repository();
  final _doLogin = PublishSubject<StandardListModels>();

  actDoLogin(Map<String, dynamic> body, void Function(StandardListModels models) callback) async {
    StandardListModels model = await _repository.actLogin(body: body);
    if (model.data != null) {
      SharedPreferencesHelper.setDoLogin(json.encode(model.toJson()));
    }
    _doLogin.sink.add(model);
    callback(model);
  }

  dispose() {
    _doLogin.close();
  }
}

final bloc = AuthBloc();