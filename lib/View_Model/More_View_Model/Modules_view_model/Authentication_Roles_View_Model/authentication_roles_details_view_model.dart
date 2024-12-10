import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role_detail_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/authentication_roles_details_repository.dart';

import '../../../../Data/Response/api_response.dart';

class AuthenticationRolesDetailsViewmodel with ChangeNotifier {
  final _myRepo = AuthenticationRolesDetailsRepository();
  ApiResponse<AuthRoleDetailsModel> authenticationRolesDetailsList =
      ApiResponse.loading();
  setAuthenticationRolesDetailsList(
      ApiResponse<AuthRoleDetailsModel> response) {
    authenticationRolesDetailsList = response;
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

  Future<void> fetchAuthenticationRolesDetailsListApi(
      String roleCode, String token,String languageType) async {
    setAuthenticationRolesDetailsList(ApiResponse.loading());
    _myRepo
        .fetchAuthenticationRolesDetailsListApi(roleCode, token, languageType)
        .then((value) {
      setAuthenticationRolesDetailsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAuthenticationRolesDetailsList(ApiResponse.error(error.toString()));
    });
  }
}
