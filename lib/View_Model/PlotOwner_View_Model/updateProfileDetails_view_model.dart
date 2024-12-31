import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Utils/Calender/date_utils.dart';
import '../../Repository/PlotOwner_Repository/updateProfileDetails_repository.dart';

class UpdateProfileDetailsViewModel with ChangeNotifier {
  final _myRepo = UpdateProfileDetailsRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> updateProfileDetailsApi(String token,dynamic data, BuildContext context) async {
    await _myRepo.updateProfileDetailsapi(token,data).then((value) {
      if (value['status'] == true) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Utils.flushBarErrorMessage(
            value['message'], Duration(seconds: 2), context);
     
     
      } else if (value['status'] == false) {
        Utils.flushBarErrorMessage(
            'Somthing went wrong.', Duration(seconds: 2), context);

        if (kDebugMode) {
          print(value.toString());
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(
          'Somthing went wrong.', Duration(seconds: 2), context);

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
