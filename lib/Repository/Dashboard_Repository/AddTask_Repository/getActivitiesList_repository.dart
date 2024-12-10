import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';

class GetActivitiesListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetActivitiesListModel> fetchGetActivitiesListApi(String token, String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getActivitiesListUrl, token.toString(),languageType);
      return response = GetActivitiesListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
