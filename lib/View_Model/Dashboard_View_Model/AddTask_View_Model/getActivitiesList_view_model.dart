import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getActivitiesList_repository.dart';

class GetActivitiesListViewmodel with ChangeNotifier {
  final _myRepo = GetActivitiesListRepository();
  ApiResponse<GetActivitiesListModel> getActivitiesList = ApiResponse.loading();
  setGetActivitiesList(ApiResponse<GetActivitiesListModel> response) {
    getActivitiesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetActivitiesListApi(String token,String languageType) async {
    setGetActivitiesList(ApiResponse.loading());
    _myRepo.fetchGetActivitiesListApi(token, languageType).then((value) {
      setGetActivitiesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetActivitiesList(ApiResponse.error("error.toString()"));
    });
  }
}
