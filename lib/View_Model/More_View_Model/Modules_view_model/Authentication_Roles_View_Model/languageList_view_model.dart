import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/languageList_view_model.dart';

import '../../../../Data/Response/api_response.dart';

class LanguageListViewmodel with ChangeNotifier {
  final _myRepo = LanguageListRepository();
  ApiResponse<LanguageListModel> languageListDetails = ApiResponse.loading();
  setLanguageList(ApiResponse<LanguageListModel> response) {
    languageListDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchLanguageListApi(String token,String languageType) async {
    setLanguageList(ApiResponse.loading());
    _myRepo.fetchLanguageListApi(token, languageType).then((value) {
      setLanguageList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setLanguageList(ApiResponse.error(error.toString()));
    });
  }
}
