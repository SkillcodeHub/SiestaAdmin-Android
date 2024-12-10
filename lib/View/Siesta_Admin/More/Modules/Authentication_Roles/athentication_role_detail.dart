import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';
import 'package:siestaamsapp/Model/More_Model/appModules_model.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role_detail_model.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_translation.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/addUpdateAuthRoleTranslations_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/appModules_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_details_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/dashboardTypes_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/languageList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/updateAuthRole_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AuthRoleDetailsPage extends StatefulWidget {
  final AuthRole authRole;

  const AuthRoleDetailsPage({super.key, required this.authRole});

  @override
  State<AuthRoleDetailsPage> createState() => _AuthRoleDetailsPageState();
}

class _AuthRoleDetailsPageState extends State<AuthRoleDetailsPage> {
  List<Language>? langList;
  Map<String, ActivityTranslation>? translationMap;
  late AuthModal authModal;
  late bool canUpdate;
  dynamic _pageError;
  List<AppModule>? modules;
  List<DashboardType>? dashboards;
  AuthRoleDetails? _currentAuthRole;
  String? _currentDashboard;
  late TextEditingController _nameCtrl;
  bool mpIsExpandedItem = true, apIsExpandedItem = true;
  late List<bool> mpIsExpandedList,
      mpAllExpanded,
      mpAllCollapsed,
      apIsExpandedList,
      apAllExpanded,
      apAllCollapsed;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
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
    langList = [];
    dashboards = [];
    translationMap = new Map();
    mpIsExpandedList = [];
    mpAllExpanded = [];
    mpAllCollapsed = [];
    apIsExpandedList = [];
    apAllExpanded = [];
    apAllCollapsed = [];
    _nameCtrl = TextEditingController();
                                                    AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);
        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();

    fetchDataFuture = fetchData();

    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleAuthenticationRoles);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _reloadData();
    });
    final authenticationRolesDetailsViewmodel =
        Provider.of<AuthenticationRolesDetailsViewmodel>(context,
            listen: false);

    authenticationRolesDetailsViewmodel.setIsDataRefresh(false);
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final languageListViewmodel =
          Provider.of<LanguageListViewmodel>(context, listen: false);
      final dashboardTypeViewmodel =
          Provider.of<DashboardTypeViewmodel>(context, listen: false);
      final appModulesViewmodel =
          Provider.of<AppModulesViewmodel>(context, listen: false);
      final authenticationRolesDetailsViewmodel =
          Provider.of<AuthenticationRolesDetailsViewmodel>(context,
              listen: false);
      languageListViewmodel.fetchLanguageListApi(token.toString(),currentAppLanguage);

      dashboardTypeViewmodel.fetchDashboardTypeListApi(token.toString(),currentAppLanguage);
      appModulesViewmodel.fetchAppModulesListApi(token.toString(),currentAppLanguage);
      authenticationRolesDetailsViewmodel
          .fetchAuthenticationRolesDetailsListApi(
              widget.authRole.roleCode.toString(), token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageListViewmodel = Provider.of<LanguageListViewmodel>(context);
    final dashboardTypeViewmodel = Provider.of<DashboardTypeViewmodel>(context);
    final appModulesViewmodel = Provider.of<AppModulesViewmodel>(context);
    final authenticationRolesDetailsViewmodel =
        Provider.of<AuthenticationRolesDetailsViewmodel>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                authenticationRolesDetailsViewmodel.setIsDataRefresh(false);

                Navigator.of(context).pop();
              }),
          backgroundColor: appPrimaryColor,
          titleSpacing: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  fetchDataFuture = fetchData();
                }),
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.authRole.roleName.toString(),
                style: TextStyle(fontSize: titleFontSize, color: Colors.white),
              ),
              Text(
                widget.authRole.roleCode!.toLowerCase(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: false,
            tabs: [
              Tab(
                child: Text(AppString.get(context).detail(),
                    style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text(AppString.get(context).module(),
                    style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text(AppString.get(context).translation(),
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        floatingActionButton: widgetFAB(context),
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
              // Render the UI with the fetched data
              return ChangeNotifierProvider<
                  AuthenticationRolesDetailsViewmodel>.value(
                value: authenticationRolesDetailsViewmodel,
                child: Consumer<AuthenticationRolesDetailsViewmodel>(
                  builder: (context, value, _) {
                    switch (value.authenticationRolesDetailsList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        if (value.authenticationRolesDetailsList.message ==
                            "No Internet Connection") {
                          return ErrorScreenWidget(
                            onRefresh: () async {
                              fetchData();
                            },
                            loadingText: value
                                .authenticationRolesDetailsList.message
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
                            AppModulesViewmodel>.value(
                          value: appModulesViewmodel,
                          child: Consumer<AppModulesViewmodel>(
                            builder: (context, value, _) {
                              switch (value.appModulesList.status!) {
                                case Status.LOADING:
                                  return Center(
                                      child: CircularProgressIndicator());

                                case Status.ERROR:
                                  if (value.appModulesList.message ==
                                      "No Internet Connection") {
                                    return ErrorScreenWidget(
                                      onRefresh: () async {
                                        fetchData();
                                      },
                                      loadingText: value.appModulesList.message
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
                                  return ChangeNotifierProvider<
                                      DashboardTypeViewmodel>.value(
                                    value: dashboardTypeViewmodel,
                                    child: Consumer<DashboardTypeViewmodel>(
                                      builder: (context, value, _) {
                                        switch (value
                                            .dashboardTypeDetails.status!) {
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
                                                    .dashboardTypeDetails
                                                    .message
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
                                            return ChangeNotifierProvider<
                                                LanguageListViewmodel>.value(
                                              value: languageListViewmodel,
                                              child: Consumer<
                                                  LanguageListViewmodel>(
                                                builder: (context, value, _) {
                                                  switch (value
                                                      .languageListDetails
                                                      .status!) {
                                                    case Status.LOADING:
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());

                                                    case Status.ERROR:
                                                      if (value
                                                              .languageListDetails
                                                              .message ==
                                                          "No Internet Connection") {
                                                        return ErrorScreenWidget(
                                                          onRefresh: () async {
                                                            fetchData();
                                                          },
                                                          loadingText: value
                                                              .languageListDetails
                                                              .message
                                                              .toString(),
                                                        );
                                                      } else {
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginScreen()),
                                                            (route) => false,
                                                          );
                                                        });
                                                        return Container();
                                                      }

                                                    case Status.COMPLETED:
                                                      if (!authenticationRolesDetailsViewmodel
                                                          .isDataRefresh) {
                                                        authenticationRolesDetailsViewmodel
                                                            .setIsDataRefresh(
                                                                true);

                                                        _currentAuthRole =
                                                            authenticationRolesDetailsViewmodel
                                                                .authenticationRolesDetailsList
                                                                .data!
                                                                .data;

                                                        _nameCtrl.text =
                                                            _currentAuthRole!
                                                                .roleName
                                                                .toString();

                                                        modules =
                                                            appModulesViewmodel
                                                                .appModulesList
                                                                .data!
                                                                .data!;
                                                        mpIsExpandedList
                                                            .clear();
                                                        mpAllExpanded.clear();
                                                        mpAllCollapsed.clear();
                                                        for (num i = 0;
                                                            i < modules!.length;
                                                            i++) {
                                                          mpIsExpandedList.add(
                                                              mpIsExpandedItem);
                                                          mpAllExpanded.add(
                                                              mpIsExpandedItem);
                                                          mpAllCollapsed.add(
                                                              !mpIsExpandedItem);
                                                        }
                                                        _currentDashboard =
                                                            _currentAuthRole!
                                                                .dashboardCode;
                                                        dashboards!.clear();
                                                        dashboards!.addAll(
                                                            dashboardTypeViewmodel
                                                                    .dashboardTypeDetails
                                                                    .data!
                                                                    .data
                                                                as Iterable<
                                                                    DashboardType>);
                                                      }

                                                      langList!.clear();
                                                      langList!.addAll(
                                                          languageListViewmodel
                                                              .languageListDetails
                                                              .data!
                                                              .data!);
                                                      translationMap!.clear();

                                                      langList!
                                                          .forEach((element) {
                                                        var translation;

                                                        if (_currentAuthRole!
                                                                .translation ==
                                                            null) {
                                                          translation =
                                                              ActivityTranslation();
                                                        } else {
                                                          var tObj = _currentAuthRole!
                                                                  .translation![
                                                              element
                                                                  .languageCode];
                                                          if (tObj != null) {
                                                            translation =
                                                                ActivityTranslation
                                                                    .fromJson(
                                                                        tObj);
                                                          } else {
                                                            translation =
                                                                ActivityTranslation();
                                                          }
                                                        }

                                                        translation
                                                                .languageCode =
                                                            element
                                                                .languageCode;
                                                        translationMap![element
                                                                .languageCode
                                                                .toString()] =
                                                            translation;
                                                      });

                                                      return Container(
                                                          color: Colors
                                                              .grey.shade200,
                                                          child: TabBarView(
                                                            children: [
                                                              widgetDetailContent(
                                                                  context),
                                                              widgetModulePermission(
                                                                  context),
                                                              widgetTranslationPage(
                                                                  context),
                                                            ],
                                                          ));
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
              );
            }
          },
        ),
      ),
    );
  }

  Widget widgetFAB(BuildContext context) {
    if (widget.authRole == _currentAuthRole &&
        _currentDashboard == widget.authRole.dashboardCode) {
      return Container();
    }
    return canUpdate
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            onPressed: _updateData,
            mini: true,
            child: Icon(Icons.save),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget widgetDetailContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        AppString.get(context).active(),
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                    ),
                    Switch(
                      value: _currentAuthRole!.isActive! > 0,
                      onChanged: (enabled) {
                        setState(() {
                          _currentAuthRole!.isActive = enabled ? 1 : 0;
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: _nameCtrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: AppString.get(context).roleName(),
                    hintText: AppString.get(context).roleName(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLength: 50,
                  onChanged: (value) {
                    setState(() {
                      _currentAuthRole!.roleName = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      _currentAuthRole!.roleName = value;
                    });
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 8),
                Text(
                  AppString.get(context).dashboardTypes(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: isActive()
                      ? BoxDecoration(
                          border: Border.all(
                            color: appPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        )
                      : null,
                  child: DropdownButton<String>(
                    value: _currentDashboard,
                    onChanged: !isActive()
                        ? null
                        : (value) {
                            setState(() {
                              print("_currentDashboard");
                              print(_currentDashboard);
                              _currentDashboard = value;
                            });
                          },
                    isExpanded: true,
                    underline: Container(),
                    items: dashboards!
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: Text(
                              e.name.toString(),
                              style: TextStyle(fontSize: titleFontSize),
                            ),
                            value: e.code,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetModulePermission(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${AppString.get(context).module()} ${AppString.get(context).permissions()}',
                  style: TextStyle(fontSize: titleFontSize),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (mpIsExpandedItem) {
                      mpIsExpandedList = mpAllCollapsed.toList();
                    } else {
                      mpIsExpandedList = mpAllExpanded.toList();
                    }
                    mpIsExpandedItem = !mpIsExpandedItem;
                  });
                },
                style: ElevatedButton.styleFrom(primary: appPrimaryColor),
                icon: Icon(
                  Icons.expand,
                  color: Colors.white,
                ),
                label: Text(
                  mpIsExpandedItem
                      ? AppString.get(context).collapse()
                      : AppString.get(context).expand(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemCount: modules!.length,
            itemBuilder: (context, index) {
              AppModule item = modules![index];
              bool isExpanded = mpIsExpandedList[index];
              return Card(
                child: ExpandedItem(
                  ExpansionEntry(
                    Container(
                      child: Text(
                        item.moduleName.toString(),
                        style: TextStyle(
                            fontSize: titleFontSize, color: appPrimaryColor),
                      ),
                    ),
                    children: [
                      widgetPermissionExpansionItem(
                        context,
                        item,
                        AppString.get(context).canAdd(),
                        _currentAuthRole!.canAdd!,
                      ),
                      widgetPermissionExpansionItem(
                        context,
                        item,
                        AppString.get(context).canView(),
                        _currentAuthRole!.canRead!,
                      ),
                      widgetPermissionExpansionItem(
                        context,
                        item,
                        AppString.get(context).canUpdate(),
                        _currentAuthRole!.canUpdate!,
                      ),
                    ],
                  ),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (value) {
                    mpIsExpandedList[index] = value;
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget widgetTranslationPage(BuildContext context) {
    return SingleChildScrollView(
      child: getTranslationItemView(context),
    );
  }

  Widget getTranslationItemView(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (var iteration in langList!)
            AuthRoleTranslationView(
              code: widget.authRole.roleCode.toString(),
              language: iteration,
              translationMap: translationMap!,
              updateParentWidget: updateParentWidget,
              canUpdate: canUpdate,
            )
        ],
      ),
    );
  }

  ExpansionEntry widgetPermissionExpansionItem(
    BuildContext context,
    AppModule item,
    String permission,
    List<String> permissionList,
  ) {
    return ExpansionEntry(
      Row(
        children: [
          Checkbox(
            // fillColor:,
            value: permissionList.contains(item.moduleCode),
            onChanged: (value) {
              setState(() {
                if (permissionList.contains(item.moduleCode)) {
                  permissionList.remove(item.moduleCode);
                } else {
                  permissionList.add(item.moduleCode.toString());
                }
              });
            },
          ),
          Text(
            permission,
            style: TextStyle(fontSize: titleFontSize),
          ),
        ],
      ),
    );
  }

  void _reloadData() {}

  void _updateData() {
    final updateAuthRoleViewModel =
        Provider.of<UpdateAuthRoleViewModel>(context, listen: false);

    if (!canUpdate) {
      return;
    }
    var isA = _currentAuthRole!.isActive! > 0;
    print("_currentAuthRole!.isActive!.toString()");
    print(isA);

    Map data = {
      'roleCode': _currentAuthRole!.roleCode.toString(),
      'roleName': _currentAuthRole!.roleName.toString(),
      'canAdd': _currentAuthRole!.canAdd!.toList(),
      'canRead': _currentAuthRole!.canRead!.toList(),
      'canUpdate': _currentAuthRole!.canUpdate!.toList(),
      'isActive': isA.toString(),
      'dashboardType': _currentDashboard.toString(),
    };
    updateAuthRoleViewModel.updateAuthRoleApi(token.toString(), data, context);
  }

  void updateParentWidget(String v) {
    _reloadData();
  }

  bool isActive() {
    return _currentAuthRole!.isActive! > 0;
  }
}

class AuthRoleTranslationView extends StatefulWidget {
  final Language language;
  final Map<String, ActivityTranslation> translationMap;
  final String code;
  final ValueChanged<String> updateParentWidget;
  final bool canUpdate;

  AuthRoleTranslationView({
    Key? key,
    required this.language,
    required this.translationMap,
    required this.code,
    required this.canUpdate,
    required this.updateParentWidget,
  }) : super(key: key);

  @override
  _AuthRoleTranslationViewState createState() {
    return _AuthRoleTranslationViewState();
  }
}

class _AuthRoleTranslationViewState extends State<AuthRoleTranslationView> {
  bool editButton = false;

  final nameCtr = TextEditingController();
  final descCtr = TextEditingController();
  bool _hasTranslation = false;
  late ActivityTranslation _translation;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;

  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();
      });
    });
    super.initState();
    _hasTranslation =
        widget.translationMap.containsKey(widget.language.languageCode);
    if (_hasTranslation) {
      _translation = widget.translationMap[widget.language.languageCode]!;
      nameCtr.text = _translation.title ?? '';
      descCtr.text = _translation.desc ?? '';
    } else {
      _translation = ActivityTranslation();
      _translation.languageCode = widget.language.languageCode;
    }
  }

  @override
  void dispose() {
    nameCtr.dispose();
    descCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getTranslationView();
  }

  List<Widget> editModeCardContextMenu() {
    return [
      IconButton(
        icon: Icon(Icons.cancel, color: Colors.black),
        onPressed: () {
          setState(() {
            editButton = false;
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.done, color: Colors.black),
        onPressed: () {
          final addUpdateAuthRoleTranslationViewModel =
              Provider.of<AddUpdateAuthRoleTranslationViewModel>(context,
                  listen: false);
          Map data = {
            'authRoleCode': widget.code.toString(),
            'language': widget
                .translationMap[widget.language.languageCode]!.languageCode,
            'translation': nameCtr.text.toString(),
            'description': descCtr.text.toString(),
          };
          addUpdateAuthRoleTranslationViewModel.addUpdateAuthRoleTranslationApi(
              token.toString(), data, context);
        },
      )
    ];
  }

  void cancelEditMode() {
    setState(() {});
  }

  void startEditMode() {
    setState(() {
      // _formPageState = Utils.FormPageState.EDIT;
    });
  }

  void startAddUpdateTranslationMode() {
    setState(() {
      // _formPageState = Utils.FormPageState.PROGRESS;
    });
  }

  Widget getEmptyTranslationView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
          elevation: 2,
          child: InkWell(
            onTap: widget.language.isActive == 1
                ? () {
                    if (widget.canUpdate) {
                      startEditMode();
                    }
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '${AppString.get(context).addTranslation()}: ${widget.language.name}',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: widget.language.isActive == 1
                          ? Colors.black
                          : Colors.grey,
                      fontStyle: widget.language.isActive == 1
                          ? FontStyle.normal
                          : FontStyle.italic),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTranslationView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8, top: 8, right: 8),
        child: Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.grey.withOpacity(0.35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${AppString.get(context).language()}: ' +
                              widget.language.name.toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      flex: 1,
                    ),
                    if (editButton) ...editModeCardContextMenu(),
                    if (!editButton && widget.canUpdate)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            editButton = true;
                          });
                        },
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    labelText:
                        '${AppString.get(context).roleCode()} ${AppString.get(context).translation()}',
                  ),
                  // enabled: _formPageState == Utils.FormPageState.EDIT,
                  enabled: editButton,

                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: nameCtr,
                  // .text != "null" ? nameCtr : null,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                    labelText: AppString.get(context).description(),
                  ),
                  enabled: editButton,

                  // enabled: _formPageState == Utils.FormPageState.EDIT,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: descCtr,
                  // .text != "null" ? descCtr : null,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  void _reInitEditFuture() {}
}
