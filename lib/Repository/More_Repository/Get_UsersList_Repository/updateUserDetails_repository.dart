import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class UpdateUserDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateUserDetailsapi(
      String id, String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateUserDetailsUrl + id, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
