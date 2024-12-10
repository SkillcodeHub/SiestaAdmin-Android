import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitySchedulerItem_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';

class GetActivitySchedulerItemRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetActivitySchedulerItemModel> fetchGetActivitySchedulerItemApi(
      String id, String token,String languageType) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getActivitySchedulersListUrl + '/' + id, token.toString(),languageType);
      return response = GetActivitySchedulerItemModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
