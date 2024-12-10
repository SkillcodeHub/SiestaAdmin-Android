import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTask.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class PriorityTaskRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<PriorityTaskModel> fetchPriorityTaskApi(
      String activityGroupCode, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.priorityTaskUrl + "?activityGroupCode=" + activityGroupCode,
          token.toString(), languageType);
      return response = PriorityTaskModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
