import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import '../../../Model/AuthCheck_Model/OwnerRegistrationPlotList_Repository/ownerRegistrationPlotList_repository.dart';
import '../../../Repository/Login_Repository/OwnerRegistrationPlotList_Repository/ownerRegistrationPlotList_repository.dart';

class OwnerRegistrationPlotListViewmodel with ChangeNotifier {
  final _myRepo = OwnerRegistrationPlotListRepository();
  ApiResponse<OwnerRegistrationPlotListModel> ownerRegistrationPlotList = ApiResponse.loading();
  setOwnerRegistrationPlotList(ApiResponse<OwnerRegistrationPlotListModel> response) {
    ownerRegistrationPlotList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchOwnerRegistrationPlotListApi() async {
    setOwnerRegistrationPlotList(ApiResponse.loading());
    _myRepo.fetchOwnerRegistrationPlotListApi().then((value) {
      setOwnerRegistrationPlotList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setOwnerRegistrationPlotList(ApiResponse.error(error.toString()));
    });
  }
}
