import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitySchedulerItem_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getActivitySchedulerItem_repository.dart';

import '../../../Data/Response/api_response.dart';

class GetActivitySchedulerItemViewmodel with ChangeNotifier {
  final _myRepo = GetActivitySchedulerItemRepository();
  ApiResponse<GetActivitySchedulerItemModel> getActivitySchedulerItem =
      ApiResponse.loading();
  setActivitySchedulerItem(
      ApiResponse<GetActivitySchedulerItemModel> response) {
    getActivitySchedulerItem = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetActivitySchedulerItemApi(String id, String token,String languageType) async {
    setActivitySchedulerItem(ApiResponse.loading());
    _myRepo.fetchGetActivitySchedulerItemApi(id, token, languageType).then((value) {
      setActivitySchedulerItem(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setActivitySchedulerItem(ApiResponse.error(error.toString()));
    });
  }
}
