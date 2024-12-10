import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddNewActivityRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addNewActivityapi(String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addNewActivityUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
