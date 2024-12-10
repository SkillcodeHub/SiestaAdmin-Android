import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/AuthCheck_Model/authCheck_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class AuthCheckRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<AuthCheckModel> fetchAuthCheckApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.authCheckUrl, token.toString(), languageType);
      return response = AuthCheckModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
