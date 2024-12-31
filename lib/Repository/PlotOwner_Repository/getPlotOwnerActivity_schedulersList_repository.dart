import '../../Data/Network/BaseApiServices.dart';
import '../../Data/Network/NetworkApiService.dart';
import '../../Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import '../../Res/app_url.dart';

class GetPlotOwnerActivitySchedulersListRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<GetActivitySchedulersListModel> fetchGetPlotOwnerActivitySchedulersListApi(
      String token,String languageType) async {
    print(token);

    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppUrl.getActivitySchedulersListUrl + "ByPlotId", token.toString(),languageType);
      return response = GetActivitySchedulersListModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
