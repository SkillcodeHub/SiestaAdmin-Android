import 'package:siestaamsapp/Model/More_Model/activityExecution_stages_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class ActivityExecutionStagesListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ActivityExecutionStagesListModel>
      fetchGetActivityExecutionStagesListApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.activityExecutionStagesListUrl, token.toString(), languageType);
      return response = ActivityExecutionStagesListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
