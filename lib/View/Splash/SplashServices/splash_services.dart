import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Main_Admin/main_admin.dart';

class SplashServices {
  var mobile;
  var userEFAW;
  UserPreferences userPreference = UserPreferences();

  Future getProviderData() => userPreference.getEmail();

  void checkAuthentication(BuildContext context) async {
    userPreference.getMobile().then((value) async {
      mobile = value;
      print('mobilemobilemobilemobilemobilemobile');
      print(mobile);
      userPreference.getUserEFAW().then((value) {
        userEFAW = value;
        print('userEFAWuserEFAWuserEFAWuserEFAWuserEFAWuserEFAW');
        print(userEFAW);

        if (userEFAW == 'false' || userEFAW == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false);
        } else if (userEFAW == 'true') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePageAdmin()));
        }
      });
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
