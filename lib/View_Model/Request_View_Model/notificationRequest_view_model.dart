import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Request_Model/notificationRequest_model.dart';
import 'package:siestaamsapp/Repository/Request_Repository/notificationRequest_repository.dart';

import '../../Data/Response/api_response.dart';

class NotificationRequestViewmodel with ChangeNotifier {
  final _myRepo = NotificationRequestRepository();
  ApiResponse<NotificationRequests> notificationRequestList =
      ApiResponse.loading();
  setNotificationRequestList(ApiResponse<NotificationRequests> response) {
    notificationRequestList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchNotificationRequestApi(String token,String languageType) async {
    setNotificationRequestList(ApiResponse.loading());
    _myRepo.fetchNotificationRequestApi(token, languageType).then((value) {
      setNotificationRequestList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setNotificationRequestList(ApiResponse.error(error.toString()));
    });
  }
}
