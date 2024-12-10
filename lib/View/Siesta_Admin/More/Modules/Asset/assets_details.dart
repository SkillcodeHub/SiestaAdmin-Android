import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsDetails_model.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsTypesList_model.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_translation.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsDetailsList_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsTypesList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/addUpdateAssetTranslations_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/updateAsset_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/languageList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/GetUsersList_View_Model/getUsersList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AssetsDetailsPage extends StatefulWidget {
  final Assets property;
  const AssetsDetailsPage({super.key, required this.property});

  @override
  State<AssetsDetailsPage> createState() => _AssetsDetailsPageState();
}

class _AssetsDetailsPageState extends State<AssetsDetailsPage> {
  dynamic _errorAsset;
  late List<Language> langList;
  late Map<String, ActivityTranslation> translationMap;
  bool assetEnabled = true;
  late TextEditingController _nameController, _numberController;
  List<AssetsTypes>? listPropertyTypes;
  late List<User> listUsers;
  AssetsTypes? _currentPropertyType;
  late AssetsDetails _currentProperty;
  User? _currentOwner;
  late Future<void> fetchDataFuture;
  late AuthModal authModal;
    late String currentAppLanguage;

  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late bool canUpdate;
  final keyForm = GlobalKey<FormState>();

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
    langList = [];
    translationMap = new Map();
    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleAsset);
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    final getAssetsDetailsListViewmodel =
        Provider.of<GetAssetsDetailsListViewmodel>(context, listen: false);

    getAssetsDetailsListViewmodel.setIsDataRefresh(false);
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getAssetsDetailsListViewmodel =
          Provider.of<GetAssetsDetailsListViewmodel>(context, listen: false);

      getAssetsDetailsListViewmodel.fetchGetAssetsDetailsListApi(
          widget.property.id.toString(), token.toString(),currentAppLanguage);

      final getUsersListViewmodel =
          Provider.of<GetUsersListViewmodel>(context, listen: false);
      getUsersListViewmodel.fetchGetUsersListApi('true', token.toString(),currentAppLanguage);
      final getAssetsTypeListViewmodel =
          Provider.of<GetAssetsTypeListViewmodel>(context, listen: false);
      getAssetsTypeListViewmodel.fetchGetAssetsTypeListApi(token.toString(),currentAppLanguage);

      final languageListViewmodel =
          Provider.of<LanguageListViewmodel>(context, listen: false);
      languageListViewmodel.fetchLanguageListApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getAssetsDetailsListViewmodel =
        Provider.of<GetAssetsDetailsListViewmodel>(context, listen: false);
    final getUsersListViewmodel = Provider.of<GetUsersListViewmodel>(context);
    final getAssetsTypeListViewmodel =
        Provider.of<GetAssetsTypeListViewmodel>(context);
    final languageListViewmodel = Provider.of<LanguageListViewmodel>(context);
    print(
        'objectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobject');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                getAssetsDetailsListViewmodel.setIsDataRefresh(false);
                Navigator.of(context).pop();
              }),
          backgroundColor: appPrimaryColor,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.property.propertyNumber ?? '-',
                style: TextStyle(fontSize: headerFontSize, color: Colors.white),
              ),
              Text(
                widget.property.propertyName ?? '-',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  AppString.get(context).detail(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(AppString.get(context).translation(),
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                fetchDataFuture = fetchData();
              },
            )
          ],
        ),
        floatingActionButton: widgetFAB(),
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
              return ChangeNotifierProvider<
                  GetAssetsDetailsListViewmodel>.value(
                value: getAssetsDetailsListViewmodel,
                child: Consumer<GetAssetsDetailsListViewmodel>(
                  builder: (context, value, _) {
                    switch (value.getAssetsDetailsList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        if (value.getAssetsDetailsList.message ==
                            "No Internet Connection") {
                          return ErrorScreenWidget(
                            onRefresh: () async {
                              fetchData();
                            },
                            loadingText:
                                value.getAssetsDetailsList.message.toString(),
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
                            GetUsersListViewmodel>.value(
                          value: getUsersListViewmodel,
                          child: Consumer<GetUsersListViewmodel>(
                            builder: (context, value, _) {
                              switch (value.getUsersList.status!) {
                                case Status.LOADING:
                                  return Center(
                                      child: CircularProgressIndicator());

                                case Status.ERROR:
                                  return Center(
                                    child: Text(
                                        value.getUsersList.message.toString()),
                                  );
                                // if (value.getUsersList.message ==
                                //     "No Internet Connection") {
                                //   return ErrorScreenWidget(
                                //     onRefresh: () async {
                                //       fetchData();
                                //     },
                                //     loadingText:
                                //         value.getUsersList.message.toString(),
                                //   );
                                // } else {
                                //   WidgetsBinding.instance
                                //       .addPostFrameCallback((_) {
                                //     Navigator.pushAndRemoveUntil(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               LoginScreen()),
                                //       (route) => false,
                                //     );
                                //   });
                                //   return Container();
                                // }

                                case Status.COMPLETED:
                                  return ChangeNotifierProvider<
                                      GetAssetsTypeListViewmodel>.value(
                                    value: getAssetsTypeListViewmodel,
                                    child: Consumer<GetAssetsTypeListViewmodel>(
                                      builder: (context, value, _) {
                                        switch (
                                            value.getAssetsTypeList.status!) {
                                          case Status.LOADING:
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());

                                          case Status.ERROR:
                                            if (value.getAssetsTypeList
                                                    .message ==
                                                "No Internet Connection") {
                                              return ErrorScreenWidget(
                                                onRefresh: () async {
                                                  fetchData();
                                                },
                                                loadingText: value
                                                    .getAssetsTypeList.message
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
                                                      print(
                                                          '222222222222222222222222222222222222222222222222222222222222222222222222222');
                                                      print(
                                                          getAssetsDetailsListViewmodel
                                                              .isDataRefresh
                                                              .toString());
                                                      if (!getAssetsDetailsListViewmodel
                                                          .isDataRefresh) {
                                                        getAssetsDetailsListViewmodel
                                                            .setIsDataRefresh(
                                                                true);
                                                        print(
                                                            '33333333333333333333333333333333333333333333333333333333333333333333333333');
                                                        listPropertyTypes =
                                                            getAssetsTypeListViewmodel
                                                                .getAssetsTypeList
                                                                .data!
                                                                .data!;
                                                        _currentProperty =
                                                            getAssetsDetailsListViewmodel
                                                                .getAssetsDetailsList
                                                                .data!
                                                                .data!;
                                                        _nameController.text =
                                                            _currentProperty
                                                                .propertyName
                                                                .toString();
                                                        _numberController.text =
                                                            _currentProperty
                                                                .propertyNumber
                                                                .toString();
                                                        if (_currentProperty
                                                                .propertyTypeCode ==
                                                            null) {
                                                          _currentPropertyType =
                                                              null;
                                                        } else {
                                                          _currentPropertyType =
                                                              AssetsTypes(
                                                            name: _currentProperty
                                                                .propertyTypeName
                                                                .toString(),
                                                            code: _currentProperty
                                                                .propertyTypeCode
                                                                .toString(),
                                                          );
                                                        }
                                                        listUsers =
                                                            getUsersListViewmodel
                                                                .getUsersList
                                                                .data!
                                                                .data!;
                                                        _currentOwner =
                                                            listUsers.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    _currentProperty
                                                                        .ownerId,
                                                                orElse: () =>
                                                                    listUsers[
                                                                        0]);
                                                      }

                                                      // -------------------------------------------------------------------------------------------

                                                      langList.clear();
                                                      langList.addAll(
                                                          languageListViewmodel
                                                              .languageListDetails
                                                              .data!
                                                              .data!);
                                                      translationMap.clear();

                                                      langList
                                                          .forEach((element) {
                                                        var translation;

                                                        if (_currentProperty
                                                                .translation ==
                                                            null) {
                                                          translation =
                                                              ActivityTranslation();
                                                        } else {
                                                          var tObj = _currentProperty
                                                                  .translation[
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
                                                        translationMap[element
                                                                .languageCode
                                                                .toString()] =
                                                            translation;
                                                      });
                                                      return Container(
                                                        color: Colors
                                                            .grey.shade200,
                                                        height:
                                                            double.maxFinite,
                                                        child: TabBarView(
                                                          children: [
                                                            SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Form(
                                                                  key: keyForm,
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      widgetDetailCard(
                                                                          context),
                                                                      widgetPropertyTypeCard(
                                                                          context),
                                                                      if (_currentPropertyType !=
                                                                              null &&
                                                                          _currentPropertyType!.code ==
                                                                              'plot')
                                                                        widgetOwnerShipCard(
                                                                            context),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            widgetTranslationPage(
                                                                context),
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
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget widgetFAB() {
    return canUpdate
        ? FloatingActionButton(
            backgroundColor: appSecondaryColor,
            mini: true,
            onPressed: () => _updateData(),
            child: Icon(Icons.done, color: Colors.black),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget widgetDetailCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    AppString.get(context).active(),
                    style: TextStyle(
                      fontSize: headerFontSize,
                    ),
                  ),
                ),
                Switch(
                    value: assetEnabled,
                    onChanged: (enabled) => enableDisableAsset(enabled)),
              ],
            ),
            TextFormField(
              controller: _nameController,
              enabled: assetEnabled,
              keyboardType: TextInputType.text,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: AppString.get(context).name(),
              ),
              validator: (value) => value == null || value.length < 2
                  ? 'Plot name must be of length 2 or more'
                  : null,
            ),
            TextFormField(
              controller: _numberController,
              enabled: assetEnabled,
              keyboardType: TextInputType.text,
              maxLength: 25,
              decoration: InputDecoration(
                labelText: AppString.get(context).number(),
              ),
              validator: (value) => value == null || value.length < 2
                  ? 'Plot number must be of length 2 or more'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetPropertyTypeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppString.get(context).propertyType(),
              style: TextStyle(
                fontSize: headerFontSize,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonFormField<AssetsTypes>(
                value: _currentPropertyType,
                isExpanded: true,
                validator: (value) =>
                    value == null ? 'Please select Property Type' : null,
                onChanged: (value) {
                  setState(() {
                    _currentPropertyType = value;
                    print(
                        'checkcheckcheckcheckcheckcheckcheckcheckcheckcheckcheckcheckcheckcheckcheck');
                    print(_currentPropertyType);
                    print(_currentPropertyType!.code);
                    if (_currentPropertyType!.code != 'plot') {
                      _currentOwner = null;
                    }
                  });
                },
                items: listPropertyTypes!
                    .toSet() // Convert to Set to remove duplicates
                    .map(
                      (e) => DropdownMenuItem<AssetsTypes>(
                        child: Text(e.name.toString()),
                        value: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetOwnerShipCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppString.get(context).ownership(),
                    style: TextStyle(
                      fontSize: headerFontSize,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentOwner = null;
                    });
                  },
                  child: Text(
                    AppString.get(context).remove(),
                    style: Theme.of(context).textTheme.button?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonFormField<User>(
                isExpanded: true,
                value: _currentOwner,
                onChanged: (value) {
                  // setState(() {
                  print(value!.id.toString());
                  _currentOwner = value;
                  // });
                },
                items: listUsers
                    .map(
                      (e) => DropdownMenuItem<User>(
                        value: e,
                        child: Container(
                          child: Text(
                            '${e.userFullname ?? '-'}\n${e.userMobile ?? '-'}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return null; // Allow null value
                  }

                  final matchingItems =
                      listUsers.where((item) => item == value);
                  if (matchingItems.length != 1) {
                    if (matchingItems.isEmpty) {
                      // Handle the case when _currentOwner is not in the listUsers
                      return 'Invalid selection. Please select a valid user from the list.';
                    } else {
                      return 'Invalid selection. Please select a valid user.';
                    }
                  }

                  return null; // Valid selection
                },
              ),
            ),
          ],
        ),
      ),
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
          for (var iteration in langList)
            AssetNameTranslationView(
              propertyId: widget.property.id!.toInt(),
              language: iteration,
              translationMap: translationMap,
              updateParentWidget: updateParentWidget,
              canUpdate: canUpdate,
            )
        ],
      ),
    );
  }

  void enableDisableAsset(bool enabled) {
    setState(() {
      assetEnabled = enabled;
    });
  }

  void _updateData() {
    if (!canUpdate) {
      return;
    }
    if (keyForm.currentState!.validate()) {
      final updateAssetViewModel =
          Provider.of<UpdateAssetViewModel>(context, listen: false);
      print("_currentOwner?.id.toString()");
      print(_currentOwner?.id.toString());
      Map data = {
        "assetName": _nameController.text.toString(),
        "assetNumber": _numberController.text.toString(),
        "isActive": assetEnabled ? "1" : "0",
        "propertyType": _currentPropertyType!.code.toString(),
        "ownerId": _currentOwner?.id.toString(),
      };
      updateAssetViewModel.updateAssetApi(
          widget.property.id.toString(), token.toString(), data, context);
    } else {
      Util.showSnackMessage(context, AppString.get(context).validateFormData());
    }
  }

  void updateParentWidget(String v) {}
}

class AssetNameTranslationView extends StatefulWidget {
  final Language language;
  final Map<String, ActivityTranslation> translationMap;
  final num propertyId;
  final ValueChanged<String> updateParentWidget;
  final bool canUpdate;

  AssetNameTranslationView({
    Key? key,
    required this.updateParentWidget,
    required this.canUpdate,
    required this.translationMap,
    required this.language,
    required this.propertyId,
  }) : super(key: key);

  @override
  _AssetNameTranslationViewState createState() {
    return _AssetNameTranslationViewState();
  }
}

class _AssetNameTranslationViewState extends State<AssetNameTranslationView> {
  final nameCtr = TextEditingController();
  final descCtr = TextEditingController();
  bool _hasTranslation = false;
  late ActivityTranslation _translation;
  bool editButton = false;
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
          final addUpdateAssetTranslationViewModel =
              Provider.of<AddUpdateAssetTranslationViewModel>(context,
                  listen: false);
          Map data = {
            'language': widget
                .translationMap[widget.language.languageCode]!.languageCode,
            'translation': nameCtr.text.toString(),
            'description': descCtr.text.toString(),
          };
          addUpdateAssetTranslationViewModel.addUpdateAssetTranslationApi(
              widget.propertyId.toString(), token.toString(), data, context);
        },
      )
    ];
  }

  void cancelEditMode() {
    setState(() {});
  }

  void startEditMode() {
    setState(() {});
  }

  void startAddUpdateTranslationMode() {
    setState(() {});
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
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
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
                          if (widget.canUpdate) {
                            setState(() {
                              editButton = true;
                            });
                          }
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
                        '${AppString.get(context).assets()} ${AppString.get(context).translation()}',
                  ),
                  enabled: editButton,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: nameCtr,
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
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: descCtr,
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
}
