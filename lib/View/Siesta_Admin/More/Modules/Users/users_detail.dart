import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Model/More_Model/getUserDetails_model.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/dashboardTypes_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/getUsersDetail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/updateUserDetails_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../Provider/app_language_provider.dart';

class UsersDetailPage extends StatefulWidget {
  final User user;

  const UsersDetailPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UsersDetailPage> createState() => _UsersDetailPageState();
}

class _UsersDetailPageState extends State<UsersDetailPage> {
  dynamic _pageError;
  late UserDetails currentUser;
  late UserDetails oldUser;
  late List<AuthRole> listAuthRoles;
  late List<DashboardType>? dashboardList;
  late AuthModal authModal;
  late bool canUpdate;
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
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

    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleUser);

    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final dashboardTypeViewmodel =
          Provider.of<DashboardTypeViewmodel>(context, listen: false);

      dashboardTypeViewmodel.fetchDashboardTypeListApi(token.toString(),currentAppLanguage);
      final authenticationRolesViewmodel =
          Provider.of<AuthenticationRolesViewmodel>(context, listen: false);

      authenticationRolesViewmodel
          .fetchAuthenticationRolesDetailsApi(token.toString(),currentAppLanguage);
      final getUserDetailsViewmodel =
          Provider.of<GetUserDetailsViewmodel>(context, listen: false);
      getUserDetailsViewmodel.fetchGetUserDetailsApi(
          widget.user.id.toString(), token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardTypeViewmodel = Provider.of<DashboardTypeViewmodel>(context);
    final getUserDetailsViewmodel =
        Provider.of<GetUserDetailsViewmodel>(context);
    final authenticationRolesViewmodel =
        Provider.of<AuthenticationRolesViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.userFullname.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
            Text(
              '${widget.user.userMobile!.truncate().toString()}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              fetchDataFuture = fetchData();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
            tooltip: AppString.get(context).refresh(),
          ),
        ],
      ),
      body: FutureBuilder<void>(
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
            return ChangeNotifierProvider<AuthenticationRolesViewmodel>.value(
              value: authenticationRolesViewmodel,
              child: Consumer<AuthenticationRolesViewmodel>(
                builder: (context, value, _) {
                  switch (value.authenticationRolesDetails.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.authenticationRolesDetails.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.authenticationRolesDetails.message
                              .toString(),
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
                      return ChangeNotifierProvider<
                          GetUserDetailsViewmodel>.value(
                        value: getUserDetailsViewmodel,
                        child: Consumer<GetUserDetailsViewmodel>(
                          builder: (context, value, _) {
                            switch (value.getUserDetails.status!) {
                              case Status.LOADING:
                                return Center(
                                    child: CircularProgressIndicator());

                              case Status.ERROR:
                                if (value.getUserDetails.message ==
                                    "No Internet Connection") {
                                  return ErrorScreenWidget(
                                    onRefresh: () async {
                                      fetchData();
                                    },
                                    loadingText:
                                        value.getUserDetails.message.toString(),
                                  );
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
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
                                currentUser = value.getUserDetails.data!.data!;
                                oldUser = currentUser;

                                return ChangeNotifierProvider<
                                    DashboardTypeViewmodel>.value(
                                  value: dashboardTypeViewmodel,
                                  child: Consumer<DashboardTypeViewmodel>(
                                    builder: (context, value, _) {
                                      switch (
                                          value.dashboardTypeDetails.status!) {
                                        case Status.LOADING:
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());

                                        case Status.ERROR:
                                          if (value.dashboardTypeDetails
                                                  .message ==
                                              "No Internet Connection") {
                                            return ErrorScreenWidget(
                                              onRefresh: () async {
                                                fetchData();
                                              },
                                              loadingText: value
                                                  .dashboardTypeDetails.message
                                                  .toString(),
                                            );
                                          } else {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                                (route) => false,
                                              );
                                            });
                                            return Container();
                                          }

                                        case Status.COMPLETED:
                                          listAuthRoles =
                                              authenticationRolesViewmodel
                                                  .authenticationRolesDetails
                                                  .data!
                                                  .data!;
                                          dashboardList = dashboardTypeViewmodel
                                              .dashboardTypeDetails.data!.data!;
                                          return widgetBody();
                                      }
                                    },
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
        },
      ),
      floatingActionButton: widgetFAB(),
    );
  }

  Widget widgetBody() {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: constraint.maxHeight,
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widgetUserInfo(context, currentUser),
              widgetActiveCard(context, currentUser),
              widgetDashboardTypes(context, currentUser),
              if (currentUser.dashboardType != "sies_pOwnr")
                widgetOwnership(context),
              widgetAuthRoles(context, currentUser),
            ],
          ),
        ),
      );
    });
  }

  Widget widgetUserInfo(BuildContext context, UserDetails user) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
              child: Icon(
                Icons.person_pin_rounded,
                size: 50,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(flex: 1)
              },
              children: [
                TableRow(children: [
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    user.userFullname.toString(),
                    style: TextStyle(color: Colors.black),
                  )
                ]),
                TableRow(children: [
                  Icon(Icons.phone, color: Colors.black),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Text(
                      user.userMobile!.truncate().toString(),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            decoration: TextDecoration.underline,
                            color: appSecondaryColor,
                          ),
                    ),
                    onTap: () async {
                      try {
                        if (await canLaunch(
                            'tel:${user.userMobile!.truncate().toString()}')) {
                          await launch(
                              'tel:${user.userMobile!.truncate().toString()}');
                        } else {
                          print('cannot launch phone dialer');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                ]),
                TableRow(children: [
                  Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Text(
                      user.userEmail ?? '',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: user.userEmail == null
                                ? Colors.white
                                : appSecondaryColor,
                            decoration: user.userEmail == null
                                ? TextDecoration.none
                                : TextDecoration.underline,
                          ),
                    ),
                    onTap: () async {
                      try {
                        if (await canLaunch(
                            'mailto:${user.userEmail?.trim()}')) {
                          await launch('mailto:${user.userEmail.trim()}');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetActiveCard(BuildContext context, UserDetails user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppString.get(context).active(),
                style: TextStyle(
                  fontSize: headerFontSize,
                ),
              ),
            ),
            Switch(
              activeColor: appPrimaryColor,
              value: currentUser.active! > 0,
              onChanged: (value) {
                setState(
                  () {
                    currentUser.active = value ? 1 : 0;
                    if (!value) {
                      currentUser.authRole?.clear();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetAuthRoles(BuildContext context, UserDetails user) {
    DashboardType? value = dashboardList?.firstWhere(
      (element) => element.code == user.dashboardType,
      orElse: () => dashboardList![0],
    );
    var currentList = listAuthRoles
        .where((element) => element.dashboardCode == currentUser.dashboardType)
        .toList();

    return Card(
      color: isActive()
          ? Theme.of(context).cardColor
          : Theme.of(context).disabledColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.get(context).authenticationRoles(),
                  style: TextStyle(
                    fontSize: headerFontSize,
                  ),
                ),
                ElevatedButton(
                  onPressed: !isActive()
                      ? null
                      : () {
                          setState(() {
                            user.authRole!.clear();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: appSecondaryColor),
                  child: Text(
                    AppString.get(context).clearAll(),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
            ...List<Widget>.generate(currentList.length, (index) {
              AuthRole currentRole = currentList[index];

              return Row(
                children: [
                  if (currentUser.dashboardType == "sies_pOwnr")
                    Radio<String>(
                      groupValue: currentRole.roleCode,
                      value: user.authRole == null || user.authRole!.isEmpty
                          ? "null"
                          : user.authRole![0],
                      onChanged: isActive()
                          ? (String? value) {
                              if (user.authRole != null) {
                                setState(() {
                                  user.authRole!.clear();
                                  user.authRole!
                                      .add(currentRole.roleCode.toString());
                                });
                              } else {
                                setState(() {
                                  List<String>? list = user.authRole;
                                  if (list == null) {
                                    list = [];
                                  }
                                  list.add(currentRole.roleCode.toString());
                                  user.authRole = list;
                                });
                              }
                            }
                          : null,
                    ),
                  if (currentUser.dashboardType != "sies_pOwnr")
                    Checkbox(
                      activeColor: appPrimaryColor,
                      value: user.authRole == null
                          ? false
                          : user.authRole!.contains(currentRole.roleCode),
                      onChanged: isActive()
                          ? (value) {
                              if (user.authRole != null &&
                                  user.authRole!
                                      .contains(currentRole.roleCode)) {
                                setState(() {
                                  user.authRole!.remove(currentRole.roleCode);
                                });
                              } else {
                                setState(() {
                                  List<String>? list = user.authRole;
                                  if (list == null) {
                                    list = [];
                                  }
                                  list.add(currentRole.roleCode.toString());
                                  user.authRole = list;
                                });
                              }
                            }
                          : null,
                    ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(currentList[index].roleName.toString()),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  DashboardType defaultValue = DashboardType(); // Create a default value

  Widget widgetDashboardTypes(BuildContext context, UserDetails? user) {
    DashboardType? value = dashboardList?.firstWhere(
      (element) => element.code == user?.dashboardType,
      orElse: () => dashboardList![0],
    );
    user!.dashboardType = value!.code;

    return Card(
      color: isActive()
          ? Theme.of(context).cardColor
          : Theme.of(context).disabledColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.get(context).dashboardTypes(),
              style: TextStyle(
                fontSize: headerFontSize,
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: isActive()
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    )
                  : null,
              child: DropdownButton<DashboardType>(
                onChanged: isActive()
                    ? (value) {
                        setState(() {
                          user.dashboardType = value!.code;
                          if (user.authRole != null) {
                            user.authRole!.clear();
                          }
                          user.plotOwnership = 0;
                        });
                      }
                    : null,
                isExpanded: true,
                value: value,
                // value != Null ? value : null,
                underline: Container(),
                items: List.generate(
                  dashboardList!.length,
                  (index) => DropdownMenuItem<DashboardType>(
                    value: dashboardList![index],
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(dashboardList![index].name.toString()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetOwnership(BuildContext context) {
    return Card(
      color: isActive()
          ? Theme.of(context).cardColor
          : Theme.of(context).disabledColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${AppString.get(context).plot()} ${AppString.get(context).ownership()}',
                style: TextStyle(
                  fontSize: headerFontSize,
                ),
              ),
            ),
            Switch(
              activeColor: appPrimaryColor,
              value: currentUser.plotOwnership! > 0,
              onChanged: !isActive()
                  ? null
                  : (value) {
                      setState(
                        () {
                          currentUser.plotOwnership = value ? 1 : 0;
                        },
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetFAB() {
    return canUpdate
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            mini: true,
            tooltip: AppString.get(context).update(),
            onPressed: _updateData,
            child: Icon(
              Icons.save,
              // color: Colors.white,
            ),
          )
        : Container(height: 0, width: 0);
  }

  void _updateData() {
    final updateUserDetailsViewModel =
        Provider.of<UpdateUserDetailsViewModel>(context, listen: false);
    var isA = currentUser.active! > 0;
    Map data = {
      "dashboardType": currentUser.dashboardType.toString(),
      "authRoles": currentUser.authRole!.toList(),
      "isActive": isA ? "1" : "0",
      "plotOwnership": currentUser.plotOwnership.toString(),
    };
    print(data);
    updateUserDetailsViewModel.updateUserDetailsApi(
        currentUser.id.toString(), token.toString(), data, context);
  }

  bool isActive() {
    return currentUser.active! > 0;
  }
}
