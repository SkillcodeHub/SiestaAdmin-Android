import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class UpdateAssetRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> updateAssetapi(String id, String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPatchApiResponse(
          AppUrl.updateAssetUrl + id, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
