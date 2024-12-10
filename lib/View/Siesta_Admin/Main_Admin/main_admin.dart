import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/MyNavigationBar/myNavigationBar.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Auth_View_Model/authCheck_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../Provider/app_language_provider.dart';
import '../../Siesta_PlotOwner/PlotOwn_NavigationBar/plotOwn_navigationBar.dart';

class HomePageAdmin extends StatefulWidget {
  HomePageAdmin({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  num bnIndex = 0;
  num _statusInitialCheck = 0;
  dynamic _errorInitialCheck;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
      late String currentAppLanguage;

  /*
    Status values meaning:
    0: IDLE
    1: PROGRESS
    2: SUCCESS
    3: ERROR
    4: LOGIN FAILURE
    5: UPDATE REQUIRED
  */
  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();
      });
    });
    super.initState();
                AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);

        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();

    fetchDataFuture = fetchData(); // Call the API only once

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final authCheckViewmodel =
          Provider.of<AuthCheckViewmodel>(context, listen: false);

      authCheckViewmodel.fetchAuthCheckApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCheckViewmodel =
        Provider.of<AuthCheckViewmodel>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<void>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  //  WaveLoaderWidget(),
                  CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else {
            // Render the UI with the fetched data
            return ChangeNotifierProvider<AuthCheckViewmodel>.value(
              value: authCheckViewmodel,
              child: Consumer<AuthCheckViewmodel>(
                builder: (context, value, _) {
                  switch (value.authCheckDetails.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.authCheckDetails.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {},
                          loadingText:
                              value.authCheckDetails.message.toString(),
                        );
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        });
                        return Container();
                      }

                    case Status.COMPLETED:
                      Provider.of<AuthStateProvider>(context, listen: false)
                          .updateLoginAuthData(
                        token:
                            value.authCheckDetails.data!.data!.token.toString(),
                        authRoles: value.authCheckDetails.data!.data!.authRole,
                        dashboardTypeCode: value
                            .authCheckDetails.data!.data!.dashboardTypeCode
                            .toString(),
                        dashboardTypeName: value
                            .authCheckDetails.data!.data!.dashboardTypeName
                            .toString(),
                        canAdd: value.authCheckDetails.data!.data!.canAdd,
                        canRead: value.authCheckDetails.data!.data!.canRead,
                        canUpdate: value.authCheckDetails.data!.data!.canUpdate,
                      );
                      return Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/images/main_bg.png'),
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.35),
                                ),
                              ),
                            ),
                            Center(
                              child: Card(
                                margin: EdgeInsets.all(16),
                                color: Colors.white70,
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppString.get(context)
                                              .appHeadingAdmin(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppString.get(context)
                                              .appSubHeading(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                color: Colors.grey.shade600,
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 48,
                                      ),
                                      ...getLoginSuccessView(context),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> widgetContentView() {
    List<Widget> w;
    switch (_statusInitialCheck) {
      case 1:
        {
          w = [...getProgressView(context)];
          break;
        }
      case 2:
        {
          w = [...getLoginSuccessView(context)];
          break;
        }
      case 3:
        {
          w = [...getErrorView(context)];
          break;
        }
      case 4:
        {
          w = [...getLoginFailureView(context, _errorInitialCheck)];
          break;
        }
      case 0:
      default:
        {
          w = [Container()];
          break;
        }
    }
    return w;
  }

  List<Widget> getProgressView(BuildContext context) {
    return [
      Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          AppString.get(context).initPleaseWait(),
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 12),
        ),
      ),
    ];
  }

  List<Widget> getLoginSuccessView(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () {
      Future.microtask(() {
        if (Provider.of<AuthStateProvider>(context, listen: false)
            .isUserAuthorized) {
          switch (Provider.of<AuthStateProvider>(context, listen: false)
              .getUserDashboard!
              .code) {
            case 'sies_admn':
              {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyNavigationBar(
                              indexNumber: 0,
                            )),
                    (route) => false);
                break;
              }
            case 'sies_pOwnr':
              {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlotOwn_NavigationBar(
                              indexNumber: 0,
                            )),
                    (route) => false);
                break;
              }
            default:
              {
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   DashboardNonMembersPage.routeName,
                //   (Route<dynamic> dynamic) => false,
                //   arguments: {
                //     'error':
                //         AppString.get(context).undefinedDashboardDetected(),
                //   },
                // );
                break;
              }
          }
        } else {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   DashboardNonMembersPage.routeName,
          //   (Route<dynamic> dynamic) => false,
          //   arguments: {
          //     'error': null,
          //     'appUrl':
          //         'https://play.google.com/store/apps/details?id=com.axon.siesta_ams.member'
          //   },
          // );
        }
      });
    });
    return [
      Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          AppString.get(context).loginSuccess(),
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 14),
        ),
      ),
    ];
  }

  List<Widget> getLoginFailureView(BuildContext context, String message) {
    return [
      Container(
        alignment: Alignment.center,
        child: Text(
          message ?? AppString.get(context).somethingWentWrong(),
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 12),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        child: ElevatedButton(
            child: Text(
              AppString.get(context).login(),
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     ExecutiveLogin.routeName, (Route<dynamic> dynamic) => false);
            }),
      ),
    ];
  }

  List<Widget> getErrorView(BuildContext context, [String? error]) {
    return [
      Container(
        alignment: Alignment.center,
        child: Text(
          error ?? AppString.get(context).somethingWentWrong(),
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 12),
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        child: ElevatedButton(
            child: Text(
              AppString.get(context).retry(),
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              setState(() {
                _reInitAuthCheckFuture();
              });
            }),
      ),
    ];
  }

  void performInitialCheck() {
    _reInitAuthCheckFuture();
    /*if (Platform.isAndroid) {
      _checkAppUpdate();
    } else {

    }*/
  }

  void _reInitAuthCheckFuture() {
    setState(() {
      _statusInitialCheck = 1;
    });

    // networkApi.authCheck(context: context).then((value) {
    //   if (value.status) {
    //     setState(() {
    //       _statusInitialCheck = 2;
    //       AuthenticationData data = AuthenticationData.fromJson(value.data);
    //       Provider.of<AuthStateProvider>(context, listen: false)
    //           .updateLoginAuthData(
    //         token: data.token,
    //         authRoles: data.authRole,
    //         dashboardTypeCode: data.dashboardTypeCode,
    //         dashboardTypeName: data.dashboardTypeName,
    //         canAdd: data.canAdd,
    //         canRead: data.canRead,
    //         canUpdate: data.canUpdate,
    //       );
    //     });
    //   } else {
    //     setState(() {
    //       _statusInitialCheck = 4;
    //       _errorInitialCheck = value.message;
    //     });
    //   }
    // }).catchError((e) {
    //   setState(() {
    //     if (e == null) {
    //       _statusInitialCheck = 2;
    //     } else if (e.runtimeType == ResponseEnvelope) {
    //       ResponseEnvelope res = e;
    //       _statusInitialCheck = 4;
    //       _errorInitialCheck = res.message;
    //     } else {
    //       _statusInitialCheck = 3;
    //       _errorInitialCheck = getErrorMessage(context, e);
    //     }
    //   });
    // });
  }

  void changeBottomNavPage(index) {
    setState(() {
      bnIndex = index;
    });
  }
}
