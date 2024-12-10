import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsDetails_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getAssetDetails_repository.dart';

class GetAssetsDetailsListViewmodel with ChangeNotifier {
  final _myRepo = GetAssetsDetailsListRepository();
  ApiResponse<GetAssetsDetailsListModel> getAssetsDetailsList =
      ApiResponse.loading();
  setGetAssetsDetailsList(ApiResponse<GetAssetsDetailsListModel> response) {
    getAssetsDetailsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _isDataRefresh = false;
  bool get isDataRefresh => _isDataRefresh;
  setIsDataRefresh(bool value) {
    _isDataRefresh = value;
    notifyListeners();
  }

  Future<void> fetchGetAssetsDetailsListApi(String id, String token,String languageType) async {
    setGetAssetsDetailsList(ApiResponse.loading());
    _myRepo.fetchGetAssetsDetailsListApi(id, token, languageType).then((value) {
      setGetAssetsDetailsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetAssetsDetailsList(ApiResponse.error(error.toString()));
    });
  }
}
