import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getActivity_schedulersList_repository.dart';

class GetActivitySchedulersListViewmodel with ChangeNotifier {
  final _myRepo = GetActivitySchedulersListRepository();
  ApiResponse<GetActivitySchedulersListModel> getActivitySchedulersList =
      ApiResponse.loading();
  setGetActivitySchedulersList(
      ApiResponse<GetActivitySchedulersListModel> response) {
    getActivitySchedulersList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetActivitySchedulersListApi(String token,String languageType) async {
    setGetActivitySchedulersList(ApiResponse.loading());
    _myRepo.fetchGetActivitySchedulersListApi(token, languageType).then((value) {
      setGetActivitySchedulersList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetActivitySchedulersList(ApiResponse.error(error.toString()));
    });
  }
}
