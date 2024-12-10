import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class AuthenticationRolesRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<AuthRoleModel> fetchAuthenticationRolesDetailsApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.authenticationRolesUrl, token.toString(), languageType);
      return response = AuthRoleModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
