import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class PendingUserRequestRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetUsersListModel> fetchPendingUserRequestApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getPendingUsersrequestListUrl, token.toString(), languageType);
      return response = GetUsersListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
