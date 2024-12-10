import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';

class GetAssetsListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetAssetsListModel> fetchGetAssetsListApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getAssetsListUrl, token.toString(),languageType);
      return response = GetAssetsListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
