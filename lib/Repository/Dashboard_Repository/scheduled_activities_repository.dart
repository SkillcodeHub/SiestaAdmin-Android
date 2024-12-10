import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduled_activities_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../Data/Network/NetworkApiService.dart';

class ScheduledActivitiesRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ScheduledActivitiesModel> fetchScheduledActivitiesApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.scheduledActivitiesUrl, token.toString(),languageType.toString());
      return response = ScheduledActivitiesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
