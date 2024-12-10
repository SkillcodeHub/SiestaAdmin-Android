import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';

import '../../../Data/Network/BaseApiServices.dart';
import '../../../Data/Network/NetworkApiService.dart';
import '../../../Res/app_url.dart';

class AddNewActivitySchedulersRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> addNewActivitySchedulersapi(
      String token, List<Activities> data) async {
    print(data);
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addNewActivitySchedulersUrl, token, data);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
