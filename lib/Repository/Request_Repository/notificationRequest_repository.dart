import 'package:siestaamsapp/Model/Request_Model/notificationRequest_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../Data/Network/BaseApiServices.dart';
import '../../Data/Network/NetworkApiService.dart';

class NotificationRequestRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<NotificationRequests> fetchNotificationRequestApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.taskStageUrl, token.toString(), languageType);
      return response = NotificationRequests.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
