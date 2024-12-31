import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';

import '../../Repository/PlotOwner_Repository/getPlotOwnerAssetsList_repository.dart';

class GetPlotOwnerAssetsListViewmodel with ChangeNotifier {
  final _myRepo = GetPlotOwnerAssetsListRepository();
  ApiResponse<GetAssetsListModel> getPlotOwnerAssetsList = ApiResponse.loading();
  setGetPlotOwnerAssetsList(ApiResponse<GetAssetsListModel> response) {
    getPlotOwnerAssetsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetPlotOwnerAssetsListApi(String token,String languageType) async {
    setGetPlotOwnerAssetsList(ApiResponse.loading());
    _myRepo.fetchGetPlotOwnerAssetsListApi(token, languageType).then((value) {
      setGetPlotOwnerAssetsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetPlotOwnerAssetsList(ApiResponse.error(error.toString()));
    });
  }
}
