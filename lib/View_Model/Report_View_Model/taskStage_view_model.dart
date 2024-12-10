import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Report_Model/taskStage_Model.dart';
import 'package:siestaamsapp/Repository/Report_Repository/taskStage_Repository.dart';

import '../../Data/Response/api_response.dart';

class TaskStageViewmodel with ChangeNotifier {
  final _myRepo = TaskStageRepository();
  ApiResponse<TaskStageModel> taskStageList = ApiResponse.loading();
  setTaskStageList(ApiResponse<TaskStageModel> response) {
    taskStageList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchTaskStageApi(String token,String languageType) async {
    setTaskStageList(ApiResponse.loading());
    _myRepo.fetchTaskStageApi(token, languageType).then((value) {
      setTaskStageList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setTaskStageList(ApiResponse.error(error.toString()));
    });
  }
}
