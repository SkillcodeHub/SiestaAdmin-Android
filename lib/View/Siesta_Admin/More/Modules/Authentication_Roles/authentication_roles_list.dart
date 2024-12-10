import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/More_Model/auth_role.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Utils;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/authentication_roles_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AuthRolesPage extends StatefulWidget {
  const AuthRolesPage({super.key});

  @override
  State<AuthRolesPage> createState() => _AuthRolesPageState();
}

class _AuthRolesPageState extends State<AuthRolesPage> {
  Utils.PageStatus pageStatus = Utils.PageStatus.IDLE;
  dynamic pageError;
  List<AuthRole>? _activeList;
  List<AuthRole>? _backupList;
  late AuthModal authModal;
  late bool canAdd;
  bool showFilterView = false;
  late TextEditingController _searchController;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  bool isSearchShows = false;
  List<AuthRole> filteredData = [];
  List<AuthRole> data = [];
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
    _activeList = [];
    _backupList = [];
    _searchController = TextEditingController();
    _activeList = [];
                                                        AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);
        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();


    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canAdd = authModal.canAdd!.contains(moduleAuthenticationRoles);
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final authenticationRolesViewmodel =
          Provider.of<AuthenticationRolesViewmodel>(context, listen: false);

      authenticationRolesViewmodel
          .fetchAuthenticationRolesDetailsApi(token.toString(),currentAppLanguage);
    });
  }

  List<AuthRole>? filterData(String searchString) {
    if (searchString.isEmpty) {
      return _backupList;
    }

    return _backupList!.where((item) {
      String propertyNumber = item.roleName.toString().toLowerCase();
      return propertyNumber.contains(searchString.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticationRolesViewmodel =
        Provider.of<AuthenticationRolesViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).authenticationRoles(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchShows ? isSearchShows = false : isSearchShows = true;
                });
              },
              icon: Icon(
                Icons.search,
                color: isSearchShows ? appSecondaryColor : Colors.white,
              ),
              color: Colors.white),
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  fetchDataFuture = fetchData();
                  isSearchShows = false;
                });
              }),
        ],
        bottom: isSearchShows
            ? PreferredSize(
                preferredSize: Size(double.maxFinite, 56),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            filteredData = filterData(value)!;
                          });
                        },
                        // onFieldSubmitted: filterData,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              // performSearchFilter(null);
                            },
                          ),
                          labelText:
                              '${AppString.get(context).roleName()} | ${AppString.get(context).roleCode()}',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      floatingActionButton: widgetFAB(),
      body: Container(
        color: Colors.grey.shade200,
        child: FutureBuilder<void>(
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
                            loadingText: value
                                .authenticationRolesDetails.message
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
                        _backupList =
                            value.authenticationRolesDetails.data!.data;
                        _activeList!.clear();
                        _activeList!.addAll(_backupList!);
                        if (!isSearchShows) {
                          filteredData =
                              value.authenticationRolesDetails.data!.data!;
                          _activeList!.clear();
                          _activeList!.addAll(filteredData);
                        }
                        return !isSearchShows
                            ? ListView.builder(
                                itemCount: _activeList!.length,
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  final item = _activeList![index];
                                  return widgetRoleItem(item);
                                },
                              )
                            : ListView.builder(
                                itemCount: filteredData.length,
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  final item = filteredData[index];
                                  return widgetRoleItem(item);
                                },
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

  Widget widgetRoleItem(AuthRole item) {
    return Card(
      child: ListTile(
        dense: true,
        title: Text(
          item.roleNameTranslation ?? item.roleName!,
          style: TextStyle(fontSize: titleFontSize),
        ),
        subtitle: Text(
          item.roleCode!,
          style: TextStyle(fontSize: descriptionFontSize),
        ),
        onTap: () {
          Navigator.pushNamed(context, RoutesName.AuthRoleDetails,
              arguments: item);
        },
      ),
    );
  }

  Widget widgetFAB() {
    return canAdd
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.authRoleAddNewPage);
            },
            mini: true,
            child: Icon(Icons.add),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget openFilter() {
    return IconButton(
      icon: Icon(
        Icons.search,
        color: showFilterView ? appSecondaryColor : Colors.white,
      ),
      onPressed: () {
        setState(() {
          showFilterView = !showFilterView;
          if (!showFilterView) _searchController.clear();
        });
      },
    );
  }
}
