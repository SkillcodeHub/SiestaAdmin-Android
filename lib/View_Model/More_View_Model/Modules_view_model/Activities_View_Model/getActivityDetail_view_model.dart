import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/getActivityDetail_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_repository/getActivityDetail_repository.dart';

import '../../../../Data/Response/api_response.dart';

class GetActivityDetailsViewmodel with ChangeNotifier {
  final _myRepo = GetActivityDetailsRepository();
  ApiResponse<ActivityDetailModel> geActivityDetails = ApiResponse.loading();
  setGetActivityDetails(ApiResponse<ActivityDetailModel> response) {
    geActivityDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _isImageRequired = false;
  bool get isImageRequired => _isImageRequired;
  setIsImageRequired(bool value) {
    _isImageRequired = value;
    notifyListeners();
  }

  Future<void> fetchGetActivityDetailsApi(
      String activityId, String token, languageType) async {
    setGetActivityDetails(ApiResponse.loading());
    _myRepo.fetchGetActivityDetailsApi(activityId, token, languageType).then((value) {
      setGetActivityDetails(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetActivityDetails(ApiResponse.error(error.toString()));
    });
  }
}
