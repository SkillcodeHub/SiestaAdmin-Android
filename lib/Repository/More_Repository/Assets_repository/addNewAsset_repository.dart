import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddNewAssetRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addNewAssetapi(String token, dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addNewAssetUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
