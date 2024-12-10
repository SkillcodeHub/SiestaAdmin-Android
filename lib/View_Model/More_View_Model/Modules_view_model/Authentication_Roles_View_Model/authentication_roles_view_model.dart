import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/authentication_roles_repository.dart';

import '../../../../Data/Response/api_response.dart';

class AuthenticationRolesViewmodel with ChangeNotifier {
  final _myRepo = AuthenticationRolesRepository();
  ApiResponse<AuthRoleModel> authenticationRolesDetails = ApiResponse.loading();
  setAuthenticationRolesDetails(ApiResponse<AuthRoleModel> response) {
    authenticationRolesDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchAuthenticationRolesDetailsApi(String token,String languageType) async {
    setAuthenticationRolesDetails(ApiResponse.loading());
    _myRepo.fetchAuthenticationRolesDetailsApi(token, languageType).then((value) {
      setAuthenticationRolesDetails(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAuthenticationRolesDetails(ApiResponse.error(error.toString()));
    });
  }
}
