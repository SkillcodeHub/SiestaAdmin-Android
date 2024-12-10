import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Asset/asset_add_new.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AssetsListPage extends StatefulWidget {
  const AssetsListPage({super.key});

  @override
  State<AssetsListPage> createState() => _AssetsListPageState();
}

class _AssetsListPageState extends State<AssetsListPage> {
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  bool isSearchShows = false;
  dynamic pageError;
  late AuthModal authModal;
  late bool canAdd;
  bool showFilterView = false;
  late TextEditingController _searchController;
  List<Assets>? _activeList, _backupList;
  List<Assets> filteredData = [];
  List<Assets> data = [];
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
    canAdd = authModal.canAdd!.contains(moduleAsset);

    _activeList = [];
    _backupList = [];
    _searchController = TextEditingController();
    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getAssetsListViewmodel =
          Provider.of<GetAssetsListViewmodel>(context, listen: false);

      getAssetsListViewmodel.fetchGetAssetsListApi(token.toString(),currentAppLanguage);
    });
  }

  List<Assets>? filterData(String searchString) {
    if (searchString.isEmpty) {
      return _backupList;
    }

    return _backupList!.where((item) {
      String propertyNumber = item.propertyName.toString().toLowerCase();
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
    final getAssetsListViewmodel = Provider.of<GetAssetsListViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Text(
          AppString.get(context).assets(),
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
            },
          )
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
                              _searchController.clear();
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
            return ChangeNotifierProvider<GetAssetsListViewmodel>.value(
              value: getAssetsListViewmodel,
              child: Consumer<GetAssetsListViewmodel>(
                builder: (context, value, _) {
                  switch (value.getAssetsList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.getAssetsList.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.getAssetsList.message.toString(),
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
                      _backupList = value.getAssetsList.data!.data!;
                      _activeList!.clear();
                      _activeList!.addAll(_backupList!);

                      if (!isSearchShows) {
                        filteredData = value.getAssetsList.data!.data!;
                        _activeList!.clear();
                        _activeList!.addAll(filteredData);
                      }

                      return !isSearchShows
                          ? ListView.builder(
                              itemCount: _activeList!.length,
                              itemBuilder: (context, index) {
                                return _propertyItem(
                                    context, _activeList![index]);
                              },
                              padding: EdgeInsets.all(8),
                            )
                          : ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return _propertyItem(
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
    );
  }

  Widget widgetFAB(BuildContext context) {
    return canAdd
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AssetAddNewPage()))
            },
            mini: true,
            elevation: 4,
            child: Icon(Icons.add),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget _propertyItem(BuildContext context, Assets property) {
    return InkWell(
      onTap: () => openDetailPage(property),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    property.propertyNameTranslation ??
                        property.propertyName ??
                        '-',
                    style: TextStyle(fontSize: titleFontSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              TableRow(children: [
                SizedBox(height: 8),
              ]),
              TableRow(children: [
                Text(
                  '${AppString.get(context).type()}: ${property.propertyTypeName ?? '---'}',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ]),
              TableRow(children: [
                SizedBox(height: 8),
              ]),
              TableRow(children: [
                Text(
                  '${AppString.get(context).owner()}: ${property.ownerName ?? '---'}',
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void openDetailPage(Assets property) {
    Navigator.of(context)
        .pushNamed(RoutesName.assetsDetailsPage, arguments: property);
  }
}
