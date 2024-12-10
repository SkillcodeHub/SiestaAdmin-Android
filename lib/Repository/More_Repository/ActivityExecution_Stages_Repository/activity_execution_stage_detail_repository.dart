import 'package:siestaamsapp/Model/More_Model/activity_execution_stage_details_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class ActivityExecutionStageDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<ActivityExecutionStageDetailsModel>
      fetchActivityExecutionStageDetailsApi(
          String stageCode, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.activityExecutionStagesListUrl + "?stageCode=" + stageCode,
          token.toString(), languageType);
      return response = ActivityExecutionStageDetailsModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
