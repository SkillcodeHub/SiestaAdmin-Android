import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/getUserDetails_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class GetUserDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetUserDetailsModel> fetchGetUserDetailsApi(
      String userId, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getUsersListUrl + userId, token.toString(), languageType);
      return response = GetUserDetailsModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
