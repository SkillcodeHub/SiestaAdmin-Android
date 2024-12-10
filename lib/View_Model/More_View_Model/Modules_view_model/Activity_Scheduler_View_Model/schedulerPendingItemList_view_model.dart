import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/schedulerPendingItemList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_Scheduler_Repository/schedulerPendingItemList_repository.dart';

import '../../../../Data/Response/api_response.dart';

class SchedulerPendingItemListViewmodel with ChangeNotifier {
  final _myRepo = SchedulerPendingItemListRepository();
  ApiResponse<SchedulerPendingItemListModel> schedulerPendingItemList =
      ApiResponse.loading();
  setSchedulerPendingItemList(
      ApiResponse<SchedulerPendingItemListModel> response) {
    schedulerPendingItemList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchSchedulerPendingItemListApi(
      String property, String id, String token,String languageType) async {
    setSchedulerPendingItemList(ApiResponse.loading());
    _myRepo.fetchSchedulerPendingItemListApi(property, id, token, languageType).then((value) {
      setSchedulerPendingItemList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSchedulerPendingItemList(ApiResponse.error(error.toString()));
    });
  }
}
