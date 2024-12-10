import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class UpdateAuthRoleRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateAuthRoleapi(String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateAuthRoleUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
