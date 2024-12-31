import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddOwnerRequestRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addOwnerRequestapi(dynamic data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostWithoutTokenApiResponse(
          AppUrl.addownerRequestUrl, data);
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
