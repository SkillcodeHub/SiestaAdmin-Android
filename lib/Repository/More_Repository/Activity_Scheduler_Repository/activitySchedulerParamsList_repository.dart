import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/activitySchedulerParamsList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class ActivitySchedulerParamsListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ActivitySchedulerParamsListModel> fetchActivitySchedulerParamsListApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.activitySchedulerParamsListUrl, token.toString(), languageType);
      return response = ActivitySchedulerParamsListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
