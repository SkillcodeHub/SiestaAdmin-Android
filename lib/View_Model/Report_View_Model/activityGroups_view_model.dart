import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Report_Model/activity_groups.dart';
import 'package:siestaamsapp/Repository/Report_Repository/activity_groups_repository.dart';

import '../../Data/Response/api_response.dart';

class ActivityGroupsViewmodel with ChangeNotifier {
  final _myRepo = ActivityGroupsRepository();
  ApiResponse<ActivityGroup> activityGroupsList = ApiResponse.loading();
  setActivityGroupsList(ApiResponse<ActivityGroup> response) {
    activityGroupsList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchActivityGroupsApi(String token,String languageType) async {
    setActivityGroupsList(ApiResponse.loading());
    _myRepo.fetchActivityGroupsApi(token, languageType).then((value) {
      setActivityGroupsList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setActivityGroupsList(ApiResponse.error(error.toString()));
    });
  }
}

class DoctorNameProvider extends ChangeNotifier {
  String name = ' ';
  String priority = '1';

  Future<void> updateTextValues(String doctorname, String doctorid) async {
    name = doctorname;
    priority = doctorid;
    notifyListeners();
    await Future.delayed(Duration.zero);
  }

  void resetData() {
    name = ' '; // Set default doctorName value here
    priority = '1'; // Set default doctorid value here
    notifyListeners();
  }
}
