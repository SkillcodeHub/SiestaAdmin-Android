import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduledById_activities_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class ScheduledActivitiesByIdRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ScheduledActivitiesByIdModel> fetchScheduledActivitiesByIdApi(
      String schedulerId, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.scheduledActivitiesByIdUrl + schedulerId, token.toString(), languageType);
      return response = ScheduledActivitiesByIdModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
