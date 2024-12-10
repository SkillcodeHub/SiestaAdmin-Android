import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role_detail_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class AuthenticationRolesDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<AuthRoleDetailsModel> fetchAuthenticationRolesDetailsListApi(
      String roleCode, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.authenticationRoleDetailsUrl + roleCode, token.toString(), languageType);
      return response = AuthRoleDetailsModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
