import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_Scheduler_Repository/schedulerPendingActivityItemList_repository.dart';

class SchedulerPendingActivityItemListViewmodel with ChangeNotifier {
  final _myRepo = SchedulerPendingActivityItemListRepository();
  ApiResponse<GetActivitiesListModel> schedulerPendingActivityItemList =
      ApiResponse.loading();
  setSchedulerPendingActivityItemList(
      ApiResponse<GetActivitiesListModel> response) {
    schedulerPendingActivityItemList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchSchedulerPendingActivityItemListApi(
      String property, String id, String token,String languageType) async {
    setSchedulerPendingActivityItemList(ApiResponse.loading());
    _myRepo
        .fetchSchedulerPendingActivityItemListApi(property, id, token, languageType)
        .then((value) {
      setSchedulerPendingActivityItemList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSchedulerPendingActivityItemList(ApiResponse.error(error.toString()));
    });
  }
}
