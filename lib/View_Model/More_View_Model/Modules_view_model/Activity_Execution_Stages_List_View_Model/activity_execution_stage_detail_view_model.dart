import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/activity_execution_stage_details_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/ActivityExecution_Stages_Repository/activity_execution_stage_detail_repository.dart';

import '../../../../Data/Response/api_response.dart';

class ActivityExecutionStageDetailsViewmodel with ChangeNotifier {
  final _myRepo = ActivityExecutionStageDetailsRepository();
  ApiResponse<ActivityExecutionStageDetailsModel> activityExecutionStagesList =
      ApiResponse.loading();
  setActivityExecutionStageDetails(
      ApiResponse<ActivityExecutionStageDetailsModel> response) {
    activityExecutionStagesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchActivityExecutionStageDetailsApi(
      String stageCode, String token,String languageType) async {
    setActivityExecutionStageDetails(ApiResponse.loading());
    _myRepo
        .fetchActivityExecutionStageDetailsApi(stageCode, token, languageType)
        .then((value) {
      setActivityExecutionStageDetails(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setActivityExecutionStageDetails(ApiResponse.error(error.toString()));
    });
  }
}
