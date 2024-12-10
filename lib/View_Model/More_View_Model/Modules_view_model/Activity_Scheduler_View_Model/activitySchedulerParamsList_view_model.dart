import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/activitySchedulerParamsList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_Scheduler_Repository/activitySchedulerParamsList_repository.dart';

import '../../../../Data/Response/api_response.dart';

class ActivitySchedulerParamsListViewmodel with ChangeNotifier {
  final _myRepo = ActivitySchedulerParamsListRepository();
  ApiResponse<ActivitySchedulerParamsListModel> activitySchedulerParamsList =
      ApiResponse.loading();
  setActivitySchedulerParamsList(
      ApiResponse<ActivitySchedulerParamsListModel> response) {
    activitySchedulerParamsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchActivitySchedulerParamsListApi(String token,String languageType) async {
    setActivitySchedulerParamsList(ApiResponse.loading());
    _myRepo.fetchActivitySchedulerParamsListApi(token, languageType).then((value) {
      setActivitySchedulerParamsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setActivitySchedulerParamsList(ApiResponse.error(error.toString()));
    });
  }
}
