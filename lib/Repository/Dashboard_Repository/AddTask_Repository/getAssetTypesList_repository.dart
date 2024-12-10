import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsTypesList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';

class GetAssetsTypeListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetAssetsTypesListModel> fetchGetAssetsTypesListApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getAssetsTypesListUrl, token.toString(),languageType);
      return response = GetAssetsTypesListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
