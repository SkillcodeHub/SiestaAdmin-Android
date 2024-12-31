import 'package:flutter/material.dart';

import '../../Data/Response/api_response.dart';
import '../../Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import '../../Repository/PlotOwner_Repository/getPlotOwnerActivity_schedulersList_repository.dart';

class GetPlotOwnerActivitySchedulersListViewmodel with ChangeNotifier {
  final _myRepo = GetPlotOwnerActivitySchedulersListRepository();
  ApiResponse<GetActivitySchedulersListModel> getPlotOwnerActivitySchedulersList =
      ApiResponse.loading();
  setGetPlotOwnerActivitySchedulersList(
      ApiResponse<GetActivitySchedulersListModel> response) {
    getPlotOwnerActivitySchedulersList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetPlotOwnerActivitySchedulersListApi(String token,String languageType) async {
    setGetPlotOwnerActivitySchedulersList(ApiResponse.loading());
    _myRepo.fetchGetPlotOwnerActivitySchedulersListApi(token, languageType).then((value) {
      setGetPlotOwnerActivitySchedulersList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetPlotOwnerActivitySchedulersList(ApiResponse.error(error.toString()));
    });
  }
}
