import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';

import '../../../Repository/Login_Repository/OwnerRegistrationPlotList_Repository/addOwnerRequest_repository.dart';
import '../../../Utils/Calender/date_utils.dart';

class AddOwnerRequestViewModel with ChangeNotifier {
  final _myRepo = AddOwnerRequestRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> addOwnerRequestApi(dynamic data, BuildContext context) async {
    await _myRepo.addOwnerRequestapi(data).then((value) {
      if (value['status'] == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Utils.flushBarErrorMessage(
            value['message'], Duration(seconds: 2), context);
     
     
      } else if (value['status'] == false) {
        Utils.flushBarErrorMessage(
           value['message'], Duration(seconds: 2), context);

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
