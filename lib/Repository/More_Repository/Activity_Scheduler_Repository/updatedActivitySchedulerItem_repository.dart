import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class UpdateActivitySchedulerItemRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateActivitySchedulerItemapi(
      String id, String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateActivitySchedulerItemUrl + id, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
