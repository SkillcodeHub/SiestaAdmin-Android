import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduled_activities_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/scheduled_activities_repository.dart';

class ScheduledActivitiesViewmodel with ChangeNotifier {
  final _myRepo = ScheduledActivitiesRepository();
  ApiResponse<ScheduledActivitiesModel> scheduledActivitiesList =
      ApiResponse.loading();
  setScheduledActivitiesList(ApiResponse<ScheduledActivitiesModel> response) {
    scheduledActivitiesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchScheduledActivitiesApi(String token,String languageType) async {
    setScheduledActivitiesList(ApiResponse.loading());
    _myRepo.fetchScheduledActivitiesApi(token, languageType).then((value) {
      setScheduledActivitiesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setScheduledActivitiesList(ApiResponse.error(error.toString()));
    });
  }
}
