import 'package:flutter/material.dart';

import '../../Data/Response/api_response.dart';
import '../../Model/PlotOwner_Model/plotOwnerScheduledActivites_model.dart';
import '../../Repository/PlotOwner_Repository/plotOwnerScheduledActivities_repository.dart';

class PlotOwnerScheduledActivitiesViewmodel with ChangeNotifier {
  final _myRepo = PlotOwnerScheduledActivitiesRepository();
  ApiResponse<PlotOwnerScheduledActivitiesModel> PlotOwnerScheduledActivitiesList =
      ApiResponse.loading();
  setPlotOwnerScheduledActivitiesList(ApiResponse<PlotOwnerScheduledActivitiesModel> response) {
    PlotOwnerScheduledActivitiesList = response;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> fetchPlotOwnerScheduledActivitiessApi(String token,String languageType) async {
    setPlotOwnerScheduledActivitiesList(ApiResponse.loading());
    _myRepo.fetchPlotOwnerScheduledActivitiesApi(token, languageType).then((value) {
      setPlotOwnerScheduledActivitiesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setPlotOwnerScheduledActivitiesList(ApiResponse.error(error.toString()));
    });
  }
}
