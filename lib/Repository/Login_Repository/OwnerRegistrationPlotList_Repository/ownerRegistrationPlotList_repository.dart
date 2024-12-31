import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Model/AuthCheck_Model/OwnerRegistrationPlotList_Repository/ownerRegistrationPlotList_repository.dart';

class OwnerRegistrationPlotListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<OwnerRegistrationPlotListModel> fetchOwnerRegistrationPlotListApi() async {

    try {
      dynamic response = await _apiServices.getGetWithoutTokenApiResponse(
          AppUrl.ownerRegistrationPlotListUrl);
      return response = OwnerRegistrationPlotListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
