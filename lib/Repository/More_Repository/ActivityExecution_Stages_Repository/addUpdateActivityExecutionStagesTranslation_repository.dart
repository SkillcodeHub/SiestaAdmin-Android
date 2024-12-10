import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddUpdateActivityExecutionStagesTranslationRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addUpdateActivityExecutionStagesTranslationapi(
      String token, dynamic data) async {
    dynamic data1 = {};

    print(data);
    try {
      dynamic response = await _apiServices.getPutApiResponse(
          AppUrl.addUpdateActivityExecutionStagesTranslationsUrl +
              "?language=" +
              data['language'] +
              "&description=" +
              data['description'] +
              "&translation=" +
              data['translation'] +
              "&stageCode=" +
              data['stageCode'],
          token,
          data1);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
