import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Get_UsersList_Repository/get_usersList_repository.dart';

import '../../../../Data/Response/api_response.dart';

class GetUsersListViewmodel with ChangeNotifier {
  final _myRepo = GetUsersListRepository();
  ApiResponse<GetUsersListModel> getUsersList = ApiResponse.loading();
  setGetUsersList(ApiResponse<GetUsersListModel> response) {
    getUsersList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchGetUsersListApi(String status, String token,String languageType) async {
    setGetUsersList(ApiResponse.loading());
    _myRepo.fetchGetUsersListApi(status, token, languageType).then((value) {
      setGetUsersList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setGetUsersList(ApiResponse.error(error.toString()));
    });
  }
}
