import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/getUsersList_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  dynamic pageError;
  bool showFilterView = false;
  late TextEditingController _searchController;
  late List<User> _activeList, _backupList;
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  bool isSearchShows = false;
  List<User> filteredData = [];
  List<User> data = [];
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


    _activeList = [];
    _backupList = [];
    _searchController = TextEditingController();
    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      
      final getUsersListViewmodel =
          Provider.of<GetUsersListViewmodel>(context, listen: false);

      getUsersListViewmodel.fetchGetUsersListApi('false', token.toString(),currentAppLanguage);
    });
  }

  List<User> filterData(String searchString) {
    if (searchString.isEmpty) {
      return _backupList;
    }

    return _backupList.where((item) {
      String fullName = item.userFullname.toString().toLowerCase();
      String mobile = item.userMobile.toString().toLowerCase();
      String email = item.userEmail.toString().toLowerCase();
      return fullName.contains(searchString.toLowerCase()) ||
          mobile.contains(searchString.toLowerCase()) ||
          email.contains(searchString.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUsersListViewmodel =
        Provider.of<GetUsersListViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).usersList(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
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
                            filteredData = filterData(value);
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                          labelText: '${AppString.get(context).name()} | '
                              '${AppString.get(context).mobile()} | '
                              '${AppString.get(context).email()}',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
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
            return ChangeNotifierProvider<GetUsersListViewmodel>.value(
              value: getUsersListViewmodel,
              child: Consumer<GetUsersListViewmodel>(
                builder: (context, value, _) {
                  switch (value.getUsersList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.getUsersList.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.getUsersList.message.toString(),
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
                      _backupList = value.getUsersList.data!.data!;
                      _activeList.clear();
                      _activeList.addAll(_backupList);
                      if (!isSearchShows) {
                        filteredData = value.getUsersList.data!.data!;
                        _activeList.clear();
                        _activeList.addAll(filteredData);
                      }
                      return Container(
                        color: Colors.grey.shade200,
                        child: !isSearchShows
                            ? ListView.builder(
                                itemCount: _activeList.length,
                                itemBuilder: (context, index) {
                                  return _userItem(context, _activeList[index]);
                                },
                                padding: EdgeInsets.all(8),
                              )
                            : ListView.builder(
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return _userItem(
                                      context, filteredData[index]);
                                },
                                padding: EdgeInsets.all(8),
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

  Widget _userItem(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.usersDetailPage,
            arguments: user);
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Flexible(
                child: Icon(
                  Icons.person_pin_rounded,
                  color: Colors.black,
                  size: 50,
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
                    Text(user.userFullname ?? "")
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(user.userMobile!.truncate().toString())
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(user.userEmail ?? '')
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
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

  void onSearchChanged(String value) {
    setState(() {
      if (value == null || value.length == 0) {
        _activeList.clear();
        _activeList.addAll(_backupList);
        return;
      }
      _activeList.clear();
      _backupList.forEach((element) {
        if ((element.userFullname != null &&
                element.userFullname!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            element.userMobile!
                .toInt()
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            (element.userEmail != null &&
                element.userEmail!
                    .toLowerCase()
                    .contains(value.toLowerCase()))) {
          _activeList.add(element);
        }
      });
    });
  }
}
