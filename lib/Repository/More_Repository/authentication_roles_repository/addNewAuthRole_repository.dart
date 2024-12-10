import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddNewAuthRoleRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addNewAuthRoleapi(String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addNewAuthRoleUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
