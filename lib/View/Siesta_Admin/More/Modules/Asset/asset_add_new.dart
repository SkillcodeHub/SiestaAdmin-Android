import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getAssetsTypesList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsTypesList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Asset_View_Model/addNewAsset_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class AssetAddNewPage extends StatefulWidget {
  const AssetAddNewPage({super.key});

  @override
  State<AssetAddNewPage> createState() => _AssetAddNewPageState();
}

class _AssetAddNewPageState extends State<AssetAddNewPage> {
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;

  bool assetEnabled = true;
  late TextEditingController _nameController, _numberController;
  dynamic _errorAsset;
  late List<AssetsTypes> listPropertyTypes;
  AssetsTypes? _currentPropertyType;
  final keyForm = GlobalKey<FormState>();
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

    _nameController = TextEditingController();
    _numberController = TextEditingController();
    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getAssetsTypeListViewmodel =
          Provider.of<GetAssetsTypeListViewmodel>(context, listen: false);

      getAssetsTypeListViewmodel.fetchGetAssetsTypeListApi(token.toString(),currentAppLanguage);
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
    final getAssetsTypeListViewmodel =
        Provider.of<GetAssetsTypeListViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).add(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              fetchDataFuture = fetchData();
            },
          ),
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
            return ChangeNotifierProvider<GetAssetsTypeListViewmodel>.value(
              value: getAssetsTypeListViewmodel,
              child: Consumer<GetAssetsTypeListViewmodel>(
                builder: (context, value, _) {
                  switch (value.getAssetsTypeList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      print(value.getAssetsTypeList.message);
                      return ErrorScreenWidget(
                        onRefresh: () async {
                          fetchData();
                        },
                        loadingText: value.getAssetsTypeList.message.toString(),
                      );
                    case Status.COMPLETED:
                      listPropertyTypes = value.getAssetsTypeList.data!.data!;
                      ;
                      _currentPropertyType = null;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            color: Colors.grey.shade200,
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                            child: SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: keyForm,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        widgetDetailCard(context),
                                        widgetPropertyTypeCard(context),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        },
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

  void _reloadData() {}

  void _updateData() {
    final addNewAssetViewModel =
        Provider.of<AddNewAssetViewModel>(context, listen: false);

    if (keyForm.currentState!.validate()) {
      Map data = {
        "assetName": _nameController.text,
        "assetNumber": _numberController.text,
        "isActive": assetEnabled ? "1" : "0",
        "assetType": _currentPropertyType!.code.toString(),
      };
      addNewAssetViewModel.addNewAssetApi(token.toString(), data, context);
    } else {
      Util.showSnackMessage(context, AppString.get(context).validateFormData());
    }
  }

  Widget widgetIsActive() {
    return Row(
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
    );
  }

  Widget widgetName() {
    return TextFormField(
      controller: _nameController,
      autofocus: true,
      enabled: assetEnabled,
      keyboardType: TextInputType.text,
      maxLength: 200,
      decoration: InputDecoration(
        labelText: AppString.get(context).name(),
      ),
      validator: (value) => value == null || value.length < 5
          ? 'Name must be of length 5 or more'
          : null,
    );
  }

  Widget widgetNumber() {
    return TextFormField(
      controller: _numberController,
      autofocus: true,
      enabled: assetEnabled,
      keyboardType: TextInputType.text,
      maxLength: 25,
      decoration: InputDecoration(
        labelText: AppString.get(context).number(),
      ),
      validator: (value) => value == null || value.length < 3
          ? 'Number must be of length 3 or more'
          : null,
    );
  }

  void enableDisableAsset(bool enabled) {
    setState(() {
      assetEnabled = enabled;
    });
  }

  Widget widgetDetailCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            widgetIsActive(),
            widgetName(),
            widgetNumber(),
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
                  _currentPropertyType = value!;
                },
                items: listPropertyTypes
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

  Widget widgetFAB() {
    return FloatingActionButton(
      backgroundColor: appSecondaryColor,
      mini: true,
      onPressed: () => _updateData(),
      child: Icon(Icons.done),
    );
  }
}
