import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class LanguageListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<LanguageListModel> fetchLanguageListApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.languageListUrl, token.toString(), languageType);
      return response = LanguageListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
