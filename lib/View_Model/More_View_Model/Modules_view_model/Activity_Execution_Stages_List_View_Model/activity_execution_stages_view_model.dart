import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/activityExecution_stages_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/ActivityExecution_Stages_Repository/activityExection_stages_repository.dart';

import '../../../../Data/Response/api_response.dart';

class ActivityExecutionStagesListViewmodel with ChangeNotifier {
  final _myRepo = ActivityExecutionStagesListRepository();
  ApiResponse<ActivityExecutionStagesListModel> activityExecutionStagesList =
      ApiResponse.loading();
  setActivityExecutionStagesList(
      ApiResponse<ActivityExecutionStagesListModel> response) {
    activityExecutionStagesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetActivityDetailsApi(String token,String languageType) async {
    setActivityExecutionStagesList(ApiResponse.loading());
    _myRepo.fetchGetActivityExecutionStagesListApi(token, languageType).then((value) {
      setActivityExecutionStagesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setActivityExecutionStagesList(ApiResponse.error(error.toString()));
    });
  }
}
