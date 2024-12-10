import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/appModules_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/appModules_repository.dart';

import '../../../../Data/Response/api_response.dart';

class AppModulesViewmodel with ChangeNotifier {
  final _myRepo = AppModulesRepository();
  ApiResponse<AppModulesModel> appModulesList = ApiResponse.loading();
  setAppModulesList(ApiResponse<AppModulesModel> response) {
    appModulesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchAppModulesListApi(String token,String languageType) async {
    setAppModulesList(ApiResponse.loading());
    _myRepo.fetchAppModulesListApi(token, languageType).then((value) {
      setAppModulesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAppModulesList(ApiResponse.error(error.toString()));
    });
  }
}
