import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTaskDetails.dart';
import 'package:siestaamsapp/Repository/Report_Repository/priorityTaskDetails_repository.dart';

import '../../Data/Response/api_response.dart';

class PriorityTaskDetailsViewmodel with ChangeNotifier {
  final _myRepo = PriorityTaskDetailsRepository();
  ApiResponse<PriorityTaskDetailsModel> priorityTaskDetailsList =
      ApiResponse.loading();
  setPriorityTaskDetailsList(ApiResponse<PriorityTaskDetailsModel> response) {
    priorityTaskDetailsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchPriorityTaskDetailsApi(
      String stage, String activityGroupCode, String token,String languageType) async {
    setPriorityTaskDetailsList(ApiResponse.loading());
    _myRepo
        .fetchPriorityTaskDetailsApi(stage, activityGroupCode, token, languageType)
        .then((value) {
      setPriorityTaskDetailsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setPriorityTaskDetailsList(ApiResponse.error(error.toString()));
    });
  }
}
