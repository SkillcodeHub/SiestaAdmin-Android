import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Repository/More_Repository/Pending_User_Request_repository/pendingUser_request_repository.dart';

import '../../../../Data/Response/api_response.dart';

class PendingUserRequestViewmodel with ChangeNotifier {
  final _myRepo = PendingUserRequestRepository();
  ApiResponse<GetUsersListModel> pendingUserRequestDetails =
      ApiResponse.loading();
  setPendingUserRequest(ApiResponse<GetUsersListModel> response) {
    pendingUserRequestDetails = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchPendingUserRequestApi(String token,String languageType) async {
    setPendingUserRequest(ApiResponse.loading());
    _myRepo.fetchPendingUserRequestApi(token, languageType).then((value) {
      setPendingUserRequest(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setPendingUserRequest(ApiResponse.error(error.toString()));
    });
  }
}
