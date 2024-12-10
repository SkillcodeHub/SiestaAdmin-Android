import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/getUserDetails_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Get_UsersList_Repository/get_userDetails_repository.dart';

import '../../../../Data/Response/api_response.dart';

class GetUserDetailsViewmodel with ChangeNotifier {
  final _myRepo = GetUserDetailsRepository();
  ApiResponse<GetUserDetailsModel> getUserDetails = ApiResponse.loading();
  setUserDetails(ApiResponse<GetUserDetailsModel> response) {
    getUserDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetUserDetailsApi(String userId, String token,String languageType) async {
    setUserDetails(ApiResponse.loading());
    _myRepo.fetchGetUserDetailsApi(userId, token, languageType).then((value) {
      setUserDetails(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserDetails(ApiResponse.error(error.toString()));
    });
  }
}
