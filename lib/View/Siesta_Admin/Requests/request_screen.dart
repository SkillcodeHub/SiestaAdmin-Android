import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Request_Model/notificationRequest_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Requests/notification_request_add_associate.dart';
import 'package:siestaamsapp/View_Model/Request_View_Model/notificationRequest_view_model.dart';
import 'package:siestaamsapp/constants/notification_types.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';

import '../../../Provider/app_language_provider.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _keyWidget = GlobalKey<NotificationRequestListWidgetState>();
  UserPreferences userPreference = UserPreferences();

  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
      late String currentAppLanguage;

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
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final notificationRequestViewmodel =
          Provider.of<NotificationRequestViewmodel>(context, listen: false);

      notificationRequestViewmodel
          .fetchNotificationRequestApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Image(
          image: AssetImage('asset/images/logo_admin.png'),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                AppString.get(context).appHeadingAdmin(),
                style: TextStyle(fontSize: headerFontSize, color: Colors.white),
              ),
            ),
            /*Container(
                child: Text(
                  'subtitle',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white, fontFamily: 'Raleway'),
                ),
              ),*/
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      fetchDataFuture = fetchData(); // Call the API only once
                    });
                  },
                  icon: Icon(Icons.refresh),
                  color: Colors.white),
             PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Timer(Duration(microseconds: 20), () {
                        Navigator.pushNamed(
                            context, RoutesName.fileUploadScreen);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppString.get(context).uploads())
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Timer(Duration(microseconds: 20), () {
                        Navigator.pushNamed(context, RoutesName.profileScreen);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chrome_reader_mode),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppString.get(context).profile())
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Timer(Duration(microseconds: 20), () {
                        Navigator.pushNamed(context, RoutesName.settingScreen).then((value) {
          if (value == true) {
            fetchDataFuture = fetchData(); // Call the API only
          }
        });;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chrome_reader_mode),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppString.get(context).settings())
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Timer(Duration(microseconds: 20), () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to logout?',
                                style: TextStyle(fontSize: descriptionFontSize),
                                textAlign: TextAlign.center,
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: appPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: 25.w,
                                        child: Center(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: titleFontSize,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    InkWell(
                                      onTap: () {
                                        userPreference.logoutProcess();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: appPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: 25.w,
                                        child: Center(
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: titleFontSize,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.chrome_reader_mode),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppString.get(context).logout())
                      ],
                    ),
                  ),
                ],
                offset: Offset(0, 40),
                color: Colors.white,
                elevation: 2,
              ),
         
           
            ],
          )
        ],
      ),
      body: NotificationRequestListWidget(
        key: _keyWidget,
      ),
    );
  }
}

class NotificationRequestListWidget extends StatefulWidget {
  NotificationRequestListWidget({Key? key}) : super(key: key);

  @override
  NotificationRequestListWidgetState createState() {
    return NotificationRequestListWidgetState();
  }
}

class NotificationRequestListWidgetState
    extends State<NotificationRequestListWidget> {
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
      late String currentAppLanguage;

  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();
      });
    });

    super.initState();
    _list = [];

                                                            AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);
        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();


    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final notificationRequestViewmodel =
          Provider.of<NotificationRequestViewmodel>(context, listen: false);
      notificationRequestViewmodel
          .fetchNotificationRequestApi(token.toString(),currentAppLanguage);
    });
  }

  List<NotificationRequests>? _list;
  dynamic _errorAPI;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationRequestViewmodel =
        Provider.of<NotificationRequestViewmodel>(context, listen: false);

    return Container(
      height: double.maxFinite,
      color: Colors.grey.shade200,
      child: FutureBuilder<void>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          } else {
            return ChangeNotifierProvider<NotificationRequestViewmodel>.value(
              value: notificationRequestViewmodel,
              child: Consumer<NotificationRequestViewmodel>(
                builder: (context, value, _) {
                  switch (value.notificationRequestList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      _errorAPI = value.notificationRequestList.message;
                      return Util.getEmptyDataView(
                        context,
                        error: Util.getErrorMessage(context, _errorAPI),
                        callback: reloadList,
                      );
                    case Status.COMPLETED:
                      _errorAPI = value.notificationRequestList.message;

                      return value.notificationRequestList.status == "true"
                          ? ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _list!.length,
                              itemBuilder: (context, index) {
                                return widgetListItem(
                                    context, _list![index], reloadList);
                              },
                            )
                          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 20),
            Text(
              "You don't have any Requests",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Requests will appear here when you receive them.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add an action, like navigating to a "Create Request" screen
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: Text(
            //     'Create Request',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
          ],
        ),
      );
                          
    //                       InkWell(
    //   onTap: () {
    //         },
    //   child: Card(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8),
    //       child: Container(
    //         child: RichText(
    //           text: TextSpan(
    //               text:
    //                   '',
    //               style: Theme.of(context).textTheme.bodyText1?.copyWith(
    //                     fontStyle: FontStyle.italic,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 16,
    //                   ),
    //               children: <TextSpan>[
    //                 TextSpan(
    //                   text: '${AppString.get(context).wantsToAdd()}: ',
    //                   style: Theme.of(context).textTheme.bodyText2?.copyWith(
    //                         fontStyle: FontStyle.normal,
    //                         fontWeight: FontWeight.normal,
    //                         fontSize: 14,
    //                       ),
    //                 ),
    //                 TextSpan(
    //                   text: AppString.get(context).associateMember(),
    //                   style: Theme.of(context).textTheme.bodyText1?.copyWith(
    //                         fontStyle: FontStyle.italic,
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 16,
    //                       ),
    //                 ),
    //               ]),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
 
                          
                          
                          
                          
                          // Util.getEmptyDataView(
                          //     context,
                          //     error: Util.getErrorMessage(context, _errorAPI),
                          //     callback: reloadList,
                          //   );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  void reloadList() {}

  Widget widgetListItem(
      BuildContext context, NotificationRequests item, Function() reloadList) {
    switch (item.notfReqType) {
      case notifTypeInsertUserAssociate:
        return NotfReqItemAddAssociate(item: item, reloadParent: reloadList);
      default:
        return widgetUnsupportedItem(context);
    }
  }

  Widget widgetUnsupportedItem(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          AppString.get(context).undefinedDashboardDetected(),
          style: TextStyle(
            fontSize: headerFontSize,
          ),
        ),
      ),
    );
  }
}
