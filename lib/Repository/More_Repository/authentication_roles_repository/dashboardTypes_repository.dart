import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class DashboardTypeRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<DashboardTypeModel> fetchDashboardTypeListApi(String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.dashboardTypeUrl, token.toString(), languageType);
      return response = DashboardTypeModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
