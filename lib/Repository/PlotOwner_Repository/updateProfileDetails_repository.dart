import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class UpdateProfileDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateProfileDetailsapi(String token,dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateProfileDetailsUrl,token, data);
      print(response); 
      return response;
    } catch (e) {
      throw e;
    }
  }
}
