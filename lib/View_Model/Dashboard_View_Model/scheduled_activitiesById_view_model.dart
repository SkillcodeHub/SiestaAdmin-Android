import 'package:flutter/material.dart';
import 'package:siestaamsapp/Data/Response/api_response.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduledById_activities_model.dart';
import 'package:siestaamsapp/Repository/Dashboard_Repository/scheduled_activitiesById_repository.dart';

class ScheduledActivitiesByIdByIdViewmodel with ChangeNotifier {
  final _myRepo = ScheduledActivitiesByIdRepository();
  ApiResponse<ScheduledActivitiesByIdModel> scheduledActivitiesByIdList =
      ApiResponse.loading();
  setScheduledActivitiesByIdList(
      ApiResponse<ScheduledActivitiesByIdModel> response) {
    scheduledActivitiesByIdList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchScheduledActivitiesByIdApi(
      String schedulerId, String token,String languageType) async {
    setScheduledActivitiesByIdList(ApiResponse.loading());
    _myRepo.fetchScheduledActivitiesByIdApi(schedulerId, token, languageType).then((value) {
      setScheduledActivitiesByIdList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setScheduledActivitiesByIdList(ApiResponse.error(error.toString()));
    });
  }
}
