import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddScheduledTaskManuallyRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addScheduledTaskManuallyapi(
      String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addScheduledTaskManuallyUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
