import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/AuthCheck_Model/authCheck_model.dart';
import 'package:siestaamsapp/Repository/Login_Repository/authCheck_repository.dart';

class AuthCheckViewmodel with ChangeNotifier {
  final _myRepo = AuthCheckRepository();
  ApiResponse<AuthCheckModel> authCheckDetails = ApiResponse.loading();
  setAuthCheckList(ApiResponse<AuthCheckModel> response) {
    authCheckDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchAuthCheckApi(String token,String languageType) async {
    setAuthCheckList(ApiResponse.loading());
    _myRepo.fetchAuthCheckApi(token, languageType).then((value) {
      setAuthCheckList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAuthCheckList(ApiResponse.error(error.toString()));
    });
  }
}
