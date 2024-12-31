import 'package:flutter/material.dart';

import '../../Data/Response/api_response.dart';
import '../../Model/PlotOwner_Model/getPlotOwnerProfile_model.dart';
import '../../Repository/PlotOwner_Repository/getPlotOwnerProfile_repository.dart';

class GetPlotOwnerProfileViewmodel with ChangeNotifier {
  final _myRepo = GetPlotOwnerProfileDetailsRepository();
  ApiResponse<GetPlotOwnerProfileDetailsModel> getPlotOwnerProfileDetails = ApiResponse.loading();
  setGetPlotOwnerProfileDetails(ApiResponse<GetPlotOwnerProfileDetailsModel> response) {
    getPlotOwnerProfileDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetPlotOwnerProfileDetailsApi(String token,String languageType) async {
    setGetPlotOwnerProfileDetails(ApiResponse.loading());
    _myRepo.fetchGetPlotOwnerProfileDetailsApi(token, languageType).then((value) {
      setGetPlotOwnerProfileDetails(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetPlotOwnerProfileDetails(ApiResponse.error(error.toString()));
    });
  }
}
