import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddUpdateAuthRoleTranslationRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addUpdateAuthRoleTranslationapi(
      String token, dynamic data) async {
    dynamic data1 = {};
    print(data);
    try {
      dynamic response = await _apiServices.getPutApiResponse(
          AppUrl.addUpdateAuthRoleTranslationsUrl +
              "?authRoleCode=" +
              data['authRoleCode'] +
              "&language=" +
              data['language'] +
              "&translation=" +
              data['translation'] +
              "&description=" +
              data['description'],
          token,
          data1);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
