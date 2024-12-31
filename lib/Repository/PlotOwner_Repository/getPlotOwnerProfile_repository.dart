import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Res/app_url.dart';

import '../../../Data/Network/NetworkApiService.dart';
import '../../Model/PlotOwner_Model/getPlotOwnerProfile_model.dart';

class GetPlotOwnerProfileDetailsRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetPlotOwnerProfileDetailsModel> fetchGetPlotOwnerProfileDetailsApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getPlotOwnerProfileDetailsUrl , token.toString(),languageType);
      return response = GetPlotOwnerProfileDetailsModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
