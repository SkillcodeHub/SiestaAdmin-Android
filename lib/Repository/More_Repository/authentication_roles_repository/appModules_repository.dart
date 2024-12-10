import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/appModules_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class AppModulesRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<AppModulesModel> fetchAppModulesListApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.appModulesListUrl, token.toString(), languageType);
      return response = AppModulesModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
