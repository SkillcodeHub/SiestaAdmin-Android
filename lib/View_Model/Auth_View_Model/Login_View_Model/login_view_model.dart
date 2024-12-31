import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Repository/Login_Repository/auth_repository.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Calender/date_utils.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Main_Admin/main_admin.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:sizer/sizer.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> loginApi(String mobile, BuildContext context) async {
    setLoading(true);
    await _myRepo.loginapi(mobile).then((value) {
      if (value['status'] == true) {
        // Timer(Duration(seconds: 2), () {
        Map data = {
          "Mobile": mobile.toString(),
        };
        Navigator.pushReplacementNamed(context, RoutesName.verifyOtp,
            arguments: data);
        setLoading(false);
        // });

        if (kDebugMode) {
          print(value.toString());
        }
      } else if (value['status'] == false) {
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Container(
                  child: AlertDialog(
                title: Center(
                  child: Text(
                    'Alert!',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                content: Text(
                  'Please enter a valid number',
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 3.h),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          authViewModel.setLoading(false);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: appPrimaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          width: 60.w,
                          child: Center(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
            });
      }
      ;
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(
          'Please enter a valid number.', Duration(seconds: 2), context);
      setLoading(false);

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> resendOTPApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _myRepo.loginapi(data).then((value) {
      if (value['status'] == true) {
        Utils.flushBarErrorMessage(
            'OTP Send Successfully', Duration(seconds: 2), context);

        setLoading(false);

        if (kDebugMode) {
          print(value.toString());
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(
          error.toString(), Duration(seconds: 2), context);

      setLoading(false);

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> otpVerifyApi(dynamic data, BuildContext context) async {
    print(' mobile :${data['mobile'].toString()}');
    print('otpNumber:${data['otpNumber'].toString()}');
    var userEFAW = 'true';
    UserPreferences userPreference = UserPreferences();
    setSignUpLoading(true);
    _myRepo.otpverifyapi(data).then((value) {
      if (value['status'] == true) {
        print('accessToken:${value['data']['accessToken'].toString()}');
        // Simulating the async functions with Future.delayed
        Future<void>.delayed(Duration(seconds: 1), () {
          userPreference.setUserEFAW(userEFAW.toString());
        }).then((_) {
          return Future<void>.delayed(Duration(seconds: 1), () {
            Map<String, dynamic> data = {
              "data": {
                // "userData": {},
                "accessToken": value['data']['accessToken'].toString(),
              }
            };
            userPreference.saveUserData(data);
          });
        }).then((_) {
          return Future<void>.delayed(Duration(seconds: 1), () {
            userPreference.setMobile(data['mobile']);
          });
        }).then((_) {
          return Future<void>.delayed(Duration(seconds: 1), () {
            Provider.of<AuthStateProvider>(context, listen: false)
                .loginWithToken((value['data']['accessToken'].toString()));
          });
        }).then((_) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePageAdmin()));

          setSignUpLoading(false);
        });

        if (kDebugMode) {
          print(value.toString());
        }
      } else if (value['status'] == false) {
        Utils.flushBarErrorMessage(
            'Invalid Request, OTP or Expired.', Duration(seconds: 2), context);
        setSignUpLoading(false);

        if (kDebugMode) {
          print(value.toString());
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(
          'Invalid Request, OTP or Expired.', Duration(seconds: 2), context);

      setSignUpLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }



}
