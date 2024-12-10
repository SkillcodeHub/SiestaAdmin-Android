import 'package:siestaamsapp/Model/Report_Model/taskStage_Model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../Data/Network/BaseApiServices.dart';
import '../../Data/Network/NetworkApiService.dart';

class TaskStageRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<TaskStageModel> fetchTaskStageApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.taskStageUrl, token.toString(), languageType);
      return response = TaskStageModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
