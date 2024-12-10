import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsDetails_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';

class GetAssetsDetailsListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetAssetsDetailsListModel> fetchGetAssetsDetailsListApi(
      String id, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getAssetsDetailsListUrl + id, token.toString(),languageType);
      return response = GetAssetsDetailsListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
