import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTaskDetails.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class PriorityTaskDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<PriorityTaskDetailsModel> fetchPriorityTaskDetailsApi(
      String stage, String activityGroupCode, String token,String languageType) async {
    print(activityGroupCode);
    print(stage);
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.priorityTaskUrl +
              "?activityGroupCode=" +
              activityGroupCode +
              "&stage=" +
              stage,
          token.toString(), languageType);
      return response = PriorityTaskDetailsModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
