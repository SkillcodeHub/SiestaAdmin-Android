import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddUpdateActivityTranslationRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addUpdateActivityTranslationapi(
      String id, String token, dynamic data) async {
    dynamic data1 = {};
    print(data);
    print(id);
    try {
      dynamic response = await _apiServices.getPutApiResponse(
          AppUrl.addUpdateActivityTranslationsUrl +
              id +
              "?language=" +
              data['language'] +
              "&description=" +
              data['description'] +
              "&translation=" +
              data['translation'],
          token,
          data1);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
