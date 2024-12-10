import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class UpdatescheduledTaskRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updatescheduledTaskapi(
      String id, String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.scheduledActivitiesByIdUrl + id, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
