import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/dashboard_type.dart';
import 'package:siestaamsapp/Model/More_Model/appModules_model.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/addNewAuthRole_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/appModules_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/dashboardTypes_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AuthRoleAddNewPage extends StatefulWidget {
  const AuthRoleAddNewPage({super.key});

  @override
  State<AuthRoleAddNewPage> createState() => _AuthRoleAddNewPageState();
}

class _AuthRoleAddNewPageState extends State<AuthRoleAddNewPage> {
  dynamic _pageError;
  AuthRole? _currentAuthRole;
  String? _currentDashboard;
  List<AppModule>? modules;
  List<DashboardType>? dashboards;
  late TextEditingController _nameCtrl, _codeCtrl;
  bool isExpandedItem = true;
  List<bool>? isExpandedList, allExpanded, allCollapsed;
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
    dashboards = [];
    isExpandedList = [];
    allExpanded = [];
    allCollapsed = [];
    _currentAuthRole = AuthRole(
      canUpdate: [],
      canRead: [],
      canAdd: [],
      isActive: 1,
    );
    _nameCtrl = TextEditingController();
    _codeCtrl = TextEditingController();
                                                        AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);
        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();


    fetchDataFuture = fetchData();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _reloadData();
    });
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final dashboardTypeViewmodel =
          Provider.of<DashboardTypeViewmodel>(context, listen: false);
      final appModulesViewmodel =
          Provider.of<AppModulesViewmodel>(context, listen: false);

      dashboardTypeViewmodel.fetchDashboardTypeListApi(token.toString(),currentAppLanguage);
      appModulesViewmodel.fetchAppModulesListApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardTypeViewmodel = Provider.of<DashboardTypeViewmodel>(context);
    final appModulesViewmodel = Provider.of<AppModulesViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                fetchDataFuture = fetchData();
              }),
        ],
        title: Text(
          '${AppString.get(context).add()} ${AppString.get(context).authenticationRoles()}',
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
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
            return ChangeNotifierProvider<DashboardTypeViewmodel>.value(
              value: dashboardTypeViewmodel,
              child: Consumer<DashboardTypeViewmodel>(
                builder: (context, value, _) {
                  switch (value.dashboardTypeDetails.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.dashboardTypeDetails.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {},
                          loadingText:
                              value.dashboardTypeDetails.message.toString(),
                        );
                      } else {
                        return Center(
                          child: Text(
                              value.dashboardTypeDetails.message.toString()),
                        );
                      }

                    case Status.COMPLETED:
                      return ChangeNotifierProvider<AppModulesViewmodel>.value(
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
                                    onRefresh: () async {},
                                    loadingText:
                                        value.appModulesList.message.toString(),
                                  );
                                } else {
                                  return Center(
                                    child: Text(value.appModulesList.message
                                        .toString()),
                                  );
                                }

                              case Status.COMPLETED:
                                modules = appModulesViewmodel
                                    .appModulesList.data!.data!;
                                isExpandedList!.clear();
                                allExpanded!.clear();
                                allCollapsed!.clear();
                                for (num i = 0; i < modules!.length; i++) {
                                  isExpandedList!.add(isExpandedItem);
                                  allExpanded!.add(isExpandedItem);
                                  allCollapsed!.add(!isExpandedItem);
                                }
                                dashboards!.clear();
                                dashboards!.addAll(dashboardTypeViewmodel
                                    .dashboardTypeDetails.data!.data!);
                                _currentDashboard = dashboards![0].code;
                                return Container(
                                  color: Colors.grey.shade200,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      widgetDetailContent(context),
                                      widgetPermission(context),
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
        },
      ),
    );
  }

  Widget widgetFAB(BuildContext context) {
    final addNewAuthRoleViewModel =
        Provider.of<AddNewAuthRoleViewModel>(context);
    return FloatingActionButton(
      backgroundColor: appSecondaryColor,
      onPressed: () {
        Map<String, Object> data = {
          'roleCode': _currentAuthRole!.roleCode.toString(),
          'roleName': _currentAuthRole!.roleName.toString(),
          'canAdd': _currentAuthRole!.canAdd!.toList(),
          'canRead': _currentAuthRole!.canRead!.toList(),
          'canUpdate': _currentAuthRole!.canUpdate!.toList(),
          'dashboardType': _currentDashboard.toString(),
        };
        addNewAuthRoleViewModel.addNewAuthRoleApi(
            token.toString(), data, context);
      },
      mini: true,
      child: Icon(Icons.done),
    );
  }

  Widget widgetDetailContent(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _codeCtrl,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: AppString.get(context).roleCode(),
                hintText: AppString.get(context).roleCode(),
                helperText: 'Role Code must be Unique',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              maxLength: 10,
              onChanged: (value) {
                setState(() {
                  _currentAuthRole!.roleCode = value;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  _currentAuthRole!.roleCode = value;
                });
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
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
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: _currentDashboard,
                onChanged: (value) {
                  setState(() {
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
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontSize: 18),
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
    );
  }

  Widget widgetPermission(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppString.get(context).permissions(),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (isExpandedItem) {
                        isExpandedList = allCollapsed!.toList();
                      } else {
                        isExpandedList = allExpanded!.toList();
                      }
                      isExpandedItem = !isExpandedItem;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: appSecondaryColor,
                    backgroundColor: appSecondaryColor,
                  ),
                  icon: Icon(
                    Icons.expand,
                    color: Colors.white,
                  ),
                  label: Text(
                    isExpandedItem
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
            flex: 1,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: modules!.length,
              itemBuilder: (context, index) {
                AppModule item = modules![index];
                bool isExpanded = isExpandedList![index];
                return Card(
                  child: ExpandedItem(
                    ExpansionEntry(
                      Container(
                        child: Text(
                          item.moduleName.toString(),
                          style: TextStyle(fontSize: titleFontSize),
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
                      isExpandedList![index] = value;
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ExpansionEntry widgetPermissionExpansionItem(BuildContext context,
      AppModule item, String permission, List<String> permissionList) {
    return ExpansionEntry(
      Row(
        children: [
          Checkbox(
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

  void _updateData() {}
}
