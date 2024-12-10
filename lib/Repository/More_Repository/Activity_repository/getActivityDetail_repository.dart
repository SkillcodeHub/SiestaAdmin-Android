import 'package:siestaamsapp/Model/More_Model/getActivityDetail_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class GetActivityDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ActivityDetailModel> fetchGetActivityDetailsApi(
      String activityId, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.activityDetailsUrl + activityId, token.toString(), languageType);
      return response = ActivityDetailModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
