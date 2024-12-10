import 'package:dio/dio.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddNotifiedTaskManuallyRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addNotifiedTaskManuallyapi(
      String token, FormData data) async {
    print(
        "datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata");
    print(data);
    print(
        "datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata");
    try {
      dynamic response = await _apiServices.getPostFormDataApiResponse(
          AppUrl.addNotifiedTaskManuallyUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
