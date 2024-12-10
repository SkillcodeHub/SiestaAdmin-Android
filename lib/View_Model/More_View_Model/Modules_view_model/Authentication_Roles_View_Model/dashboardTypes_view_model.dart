import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/dashboardTypes_repository.dart';

import '../../../../Data/Response/api_response.dart';

class DashboardTypeViewmodel with ChangeNotifier {
  final _myRepo = DashboardTypeRepository();
  ApiResponse<DashboardTypeModel> dashboardTypeDetails = ApiResponse.loading();
  setDashboardTypeList(ApiResponse<DashboardTypeModel> response) {
    dashboardTypeDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchDashboardTypeListApi(String token,String languageType) async {
    setDashboardTypeList(ApiResponse.loading());
    _myRepo.fetchDashboardTypeListApi(token, languageType).then((value) {
      setDashboardTypeList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setDashboardTypeList(ApiResponse.error(error.toString()));
    });
  }
}
