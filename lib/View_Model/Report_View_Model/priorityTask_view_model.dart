import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTask.dart';
import 'package:siestaamsapp/Repository/Report_Repository/priorityTask_repository.dart';

import '../../Data/Response/api_response.dart';

class PriorityTaskViewmodel with ChangeNotifier {
  final _myRepo = PriorityTaskRepository();
  ApiResponse<PriorityTaskModel> priorityTaskList = ApiResponse.loading();
  setPriorityTaskList(ApiResponse<PriorityTaskModel> response) {
    priorityTaskList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchPriorityTaskApi(
      String activityGroupCode, String token,String languageType) async {
    setPriorityTaskList(ApiResponse.loading());
    _myRepo.fetchPriorityTaskApi(activityGroupCode, token, languageType).then((value) {
      setPriorityTaskList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setPriorityTaskList(ApiResponse.error(error.toString()));
    });
  }
}
