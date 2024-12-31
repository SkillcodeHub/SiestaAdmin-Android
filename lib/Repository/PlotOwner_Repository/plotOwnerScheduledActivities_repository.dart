
import '../../Data/Network/BaseApiServices.dart';
import '../../Data/Network/NetworkApiService.dart';
import '../../Model/PlotOwner_Model/plotOwnerScheduledActivites_model.dart';
import '../../Res/app_url.dart';

class PlotOwnerScheduledActivitiesRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<PlotOwnerScheduledActivitiesModel> fetchPlotOwnerScheduledActivitiesApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.scheduledActivitiesUrl+ '/owner', token.toString(),languageType.toString());
      return response = PlotOwnerScheduledActivitiesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}