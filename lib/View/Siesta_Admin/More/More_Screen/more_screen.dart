import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  UserPreferences userPreference = UserPreferences();

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
setState(() {
  
});          }
        });
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
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.all(8),
          height: constraint.maxHeight,
          width: constraint.maxWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FeatureModuleTitleCard(
                  AppString.get(context).module(),
                  featuresList(context),
                ),
                _FeatureModuleTitleCard(
                  AppString.get(context).requests(),
                  requestsList(context),
                ),
                _FeatureModuleTitleCard(
                  AppString.get(context).others(),
                  othersList(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_ModuleItemElement> featuresList(BuildContext context) {
    var list = [
      _ModuleItemElement(
        title: AppString.get(context).activityScheduler(),
        moduleCode: moduleActivityScheduler,
        onTap: () =>
            {Navigator.pushNamed(context, RoutesName.ActivitySchedulerList)},
      ),
      _ModuleItemElement(
        title: AppString.get(context).activities(),
        moduleCode: moduleActivity,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.ActivityList);
        },
      ),
      _ModuleItemElement(
        title: AppString.get(context).users(),
        moduleCode: moduleUser,
        onTap: () => {Navigator.pushNamed(context, RoutesName.usersListPage)},
      ),
      _ModuleItemElement(
        title: AppString.get(context).assets(),
        moduleCode: moduleAsset,
        onTap: () => {Navigator.pushNamed(context, RoutesName.assetsListPage)},
      ),
      _ModuleItemElement(
        title: AppString.get(context).authenticationRoles(),
        moduleCode: moduleAuthenticationRoles,
        onTap: () => {Navigator.pushNamed(context, RoutesName.authRolesPage)},
      ),
    ];
    list.sort((a, b) {
      return a.title.compareTo(b.title);
    });
    return list;
  }

  List<_ModuleItemElement> requestsList(BuildContext context) {
    var list = [
      _ModuleItemElement(
        title: AppString.get(context).newUserRequests(),
        moduleCode: modulePendingMemberRequest,
        onTap: () =>
            {Navigator.pushNamed(context, RoutesName.pendingUsersListPage)},
      ),
    ];
    list.sort((a, b) {
      return a.title.compareTo(b.title);
    });
    return list;
  }

  List<_ModuleItemElement> othersList(BuildContext context) {
    var list = [
      _ModuleItemElement(
        title: AppString.get(context).activityStages(),
        moduleCode: constantsActivityExecutionStage,
        onTap: () => {
          Navigator.pushNamed(
              context, RoutesName.activityExecutionStagesListPage)
        },
      ),
    ];
    list.sort((a, b) {
      return a.title.compareTo(b.title);
    });
    return list;
  }
}

class _FeatureModuleTitleCard extends StatelessWidget {
  final List<Widget> childrenList;
  final String headerTitle;

  _FeatureModuleTitleCard(this.headerTitle, this.childrenList, {Key? key})
      : super(key: key);

  Widget getTitleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: headerFontSize,
      ),
    );
  }

  List<Widget> _getChildrenList(
    BuildContext context,
    String title,
    List<Widget> list,
  ) {
    List<Widget> childrenList = [];
    childrenList.add(getTitleWidget(context, title));
    childrenList.add(Divider(
      color: Colors.grey,
    ));
    childrenList.addAll(list);
    return childrenList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _getChildrenList(context, headerTitle, childrenList),
        ),
      ),
    );
  }
}

class _ModuleItemElement extends StatelessWidget {
  final String title, moduleCode;
  final Function()? onTap;
  final bool enabled;

  _ModuleItemElement({
    required this.title,
    required this.onTap,
    this.enabled = true,
    required this.moduleCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthModal authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    bool canView = authModal.canRead!.contains(moduleCode);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: canView ? Colors.black : Colors.grey.shade400),
      ),
      leading: Icon(
        Icons.insert_chart,
        color: canView ? Colors.black : Colors.grey.shade400,
      ),
      onTap: canView ? onTap : null,
      enabled: canView,
    );
  }
}
