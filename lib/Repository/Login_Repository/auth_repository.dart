import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginapi(String mobile) async {
    try {
      dynamic response = await _apiServices.getGetWithoutTokenApiResponse(
          AppUrl.loginUrl + '?mobile=' + mobile.toString());
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> otpverifyapi(dynamic otpVerifyData) async {
    try {
      dynamic response = await _apiServices.getPostWithoutTokenApiResponse(
          AppUrl.otpverifyUrl, otpVerifyData);
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
