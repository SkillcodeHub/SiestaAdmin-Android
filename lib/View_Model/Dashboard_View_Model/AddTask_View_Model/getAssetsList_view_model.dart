import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getAssetList_repository.dart';

class GetAssetsListViewmodel with ChangeNotifier {
  final _myRepo = GetAssetsListRepository();
  ApiResponse<GetAssetsListModel> getAssetsList = ApiResponse.loading();
  setGetAssetsList(ApiResponse<GetAssetsListModel> response) {
    getAssetsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetAssetsListApi(String token,String languageType) async {
    setGetAssetsList(ApiResponse.loading());
    _myRepo.fetchGetAssetsListApi(token, languageType).then((value) {
      setGetAssetsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetAssetsList(ApiResponse.error(error.toString()));
    });
  }
}
