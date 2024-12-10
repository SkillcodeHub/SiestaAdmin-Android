import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Repository/More_Repository/authentication_roles_repository/updateAuthRole_repository.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_details_view_model.dart';
import 'package:sizer/sizer.dart';

class UpdateAuthRoleViewModel with ChangeNotifier {
  final _myRepo = UpdateAuthRoleRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _updateAuthRoleLoading = false;
  bool get updateAuthRoleLoading => _updateAuthRoleLoading;

  setUpdateAuthRoleLoading(bool value) {
    _updateAuthRoleLoading = value;
    notifyListeners();
  }

  Future<void> updateAuthRoleApi(
      String token, dynamic data, BuildContext context) async {
    final authenticationRolesDetailsViewmodel =
        Provider.of<AuthenticationRolesDetailsViewmodel>(context,
            listen: false);

    print(data);
    setLoading(true);
    await _myRepo.updateAuthRoleapi(token, data).then((value) {
      if (value['status'] == true) {
        print('Role Updated Successfully');
        Navigator.pop(context);
        setLoading(false);
        authenticationRolesDetailsViewmodel.setIsDataRefresh(false);

        if (kDebugMode) {
          print(value.toString());
        }
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Center(
                    child: Text(
                      'Success',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Text(
                'AuthRole Updated',
                style: TextStyle(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                SizedBox(
                  width: 80.w,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
      ;
    }).onError((error, stackTrace) {
      setLoading(false);
      authenticationRolesDetailsViewmodel.setIsDataRefresh(false);

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Container(
                  height: 30.h,
                  child: Lottie.asset('images/errorLogo.json',
                      reverse: false, repeat: false, fit: BoxFit.cover),
                ),
                Center(
                  child: Text(
                    'Aleart!',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              error.toString(),
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              SizedBox(
                width: 80.w,
                child: ElevatedButton(
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
