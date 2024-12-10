import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';

class GetActivitySchedulersListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetActivitySchedulersListModel> fetchGetActivitySchedulersListApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getActivitySchedulersListUrl, token.toString(),languageType);
      return response = GetActivitySchedulersListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
