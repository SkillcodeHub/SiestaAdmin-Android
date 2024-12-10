import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitiesList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  dynamic pageError;
  late bool canAdd;
  bool isSearchShows = false;

  List<Activities>? _activeList, _backupList;
  bool showFilterView = true;
  TextEditingController? _searchController;
  UserPreferences userPreference = UserPreferences();
  late AuthModal authModal;

  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  List<Activities> filteredData = [];
  List<Activities> data = [];
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
    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canAdd = authModal.canAdd!.contains(moduleActivity);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _searchController!.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getActivitiesListViewmodel =
          Provider.of<GetActivitiesListViewmodel>(context, listen: false);

      getActivitiesListViewmodel.fetchGetActivitiesListApi(token.toString(),currentAppLanguage);
    });
  }

  List<Activities>? filterData(String searchString) {
    if (searchString.isEmpty) {
      return _backupList;
    }

    return _backupList!.where((item) {
      String propertyNumber = item.activityName.toString().toLowerCase();
      return propertyNumber.contains(searchString.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final getActivitiesListViewmodel =
        Provider.of<GetActivitiesListViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).activities(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          // if (_backupList!.isNotEmpty) openFilter(),
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
              onPressed: () {
                setState(() {
                  _searchController!.clear();
                  fetchDataFuture = fetchData();
                  isSearchShows = false;
                });
              },
              icon: Icon(Icons.refresh),
              color: Colors.white),
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
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController!.clear();
                            },
                          ),
                          labelText:
                              '${AppString.get(context).activity()} ${AppString.get(context).name()}/${AppString.get(context).assets()} ${AppString.get(context).name()}',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      floatingActionButton: widgetFAB(context),
      body: Container(
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
              // Render the UI with the fetched data
              return ChangeNotifierProvider<GetActivitiesListViewmodel>.value(
                value: getActivitiesListViewmodel,
                child: Consumer<GetActivitiesListViewmodel>(
                  builder: (context, value, _) {
                    switch (value.getActivitiesList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        if (value.getActivitiesList.message ==
                            "No Internet Connection") {
                          return ErrorScreenWidget(
                            onRefresh: () async {
                              fetchData();
                            },
                            loadingText:
                                value.getActivitiesList.message.toString(),
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
                        _backupList = value.getActivitiesList.data!.data!;
                        _activeList!.clear();
                        _activeList!.addAll(_backupList!);

                        if (!isSearchShows) {
                          filteredData = value.getActivitiesList.data!.data!;
                          _activeList!.clear();
                          _activeList!.addAll(filteredData);
                        }

                        return !isSearchShows
                            ? ListView.builder(
                                itemCount: _activeList!.length,
                                itemBuilder: (context, index) {
                                  return _taskItem(
                                      context, _activeList![index]);
                                },
                                padding: EdgeInsets.all(8),
                              )
                            : ListView.builder(
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return _taskItem(
                                      context, filteredData[index]);
                                },
                                padding: EdgeInsets.all(8),
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

  Widget _taskItem(BuildContext context, Activities activity) {
    bool showError = activity.activityName == null;
    return GestureDetector(
      onTap: () => _openItemDetail(context, activity),
      child: Card(
        color: showError
            ? Colors.red
            : activity.active == 1
                ? Colors.white
                : Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Text(
                  activity.activityNameTranslation ??
                      activity.activityName ??
                      "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: titleFontSize),
                ),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 5,
                )
              ]),
              TableRow(
                children: [
                  Text(
                    activity.activityDescriptionTranslation ??
                        activity.activityDescription ??
                        "",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                ],
              ),
              TableRow(children: [
                SizedBox(
                  height: 5,
                )
              ]),
              TableRow(
                children: [
                  Text(
                    '${AppString.get(context).maxSkipTimeoutDays()} : ${activity.maxSkipTimeoutDays}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: subDescriptionFontSize),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openItemDetail(BuildContext context, Activities activity) {
    Navigator.pushNamed(context, RoutesName.ActivityDetailPage,
        arguments: activity);
  }

  Widget widgetFAB(BuildContext context) {
    return canAdd
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            onPressed: () =>
                {Navigator.pushNamed(context, RoutesName.ActivityAddNewPage)},
            mini: true,
            elevation: 4,
            child: Icon(Icons.add),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }
}
