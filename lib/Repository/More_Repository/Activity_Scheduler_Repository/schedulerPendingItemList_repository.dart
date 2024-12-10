import 'package:siestaamsapp/Data/Network/BaseApiServices.dart';
import 'package:siestaamsapp/Data/Network/NetworkApiService.dart';
import 'package:siestaamsapp/Model/More_Model/schedulerPendingItemList_model.dart';
import 'package:siestaamsapp/Res/app_url.dart';

class SchedulerPendingItemListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<SchedulerPendingItemListModel> fetchSchedulerPendingItemListApi(
      String property, String id, String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.schedulerPendingItemListUrl +
              "?item=" +
              property +
              "&id=" +
              id,
          token.toString(), languageType);
      return response = SchedulerPendingItemListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
