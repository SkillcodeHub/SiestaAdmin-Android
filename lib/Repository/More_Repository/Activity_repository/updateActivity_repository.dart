import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class UpdateActivityRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateActivityapi(
      String id, String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateActivityUrl + id, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
