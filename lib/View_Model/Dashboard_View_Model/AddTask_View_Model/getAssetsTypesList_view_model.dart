import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsTypesList_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/AddTask_Repository/getAssetTypesList_repository.dart';

class GetAssetsTypeListViewmodel with ChangeNotifier {
  final _myRepo = GetAssetsTypeListRepository();
  ApiResponse<GetAssetsTypesListModel> getAssetsTypeList =
      ApiResponse.loading();
  setGetAssetsTypeList(ApiResponse<GetAssetsTypesListModel> response) {
    getAssetsTypeList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetAssetsTypeListApi(String token,String languageType) async {
    setGetAssetsTypeList(ApiResponse.loading());
    _myRepo.fetchGetAssetsTypesListApi(token, languageType).then((value) {
      setGetAssetsTypeList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetAssetsTypeList(ApiResponse.error(error.toString()));
    });
  }
}
