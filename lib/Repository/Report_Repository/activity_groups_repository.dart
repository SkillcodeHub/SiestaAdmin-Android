import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/Report_Model/activity_groups.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class ActivityGroupsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ActivityGroup> fetchActivityGroupsApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.activityGroupsUrl, token.toString(), languageType);
      return response = ActivityGroup.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
