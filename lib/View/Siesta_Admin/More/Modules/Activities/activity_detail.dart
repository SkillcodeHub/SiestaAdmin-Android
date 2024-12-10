import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Model/More_Model/getActivityDetail_model.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Provider/app_language_provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_translation.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/addUpdateActivityTranslation_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/getActivityDetail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/updateActivity_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/languageList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activities activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late TextEditingController _nameController,
      _descriptionController,
      _msdController;
  late bool activityEnabled = true,
      enableEditingForEnglish = false,
      isImageRequired;
  Activities? edited;
  late AppLanguageProvider appStringProvider;
  late List<Language>? langList;
  Map<String, ActivityTranslation>? translationMap;
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  String? activityId;
  dynamic _errorActivity;
  late AuthModal authModal;
  late bool canUpdate;
  bool editButton = false;
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

    final getActivityDetailsViewmodel =
        Provider.of<GetActivityDetailsViewmodel>(context, listen: false);

    getActivityDetailsViewmodel.setIsImageRequired(false);

    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleActivity);
    langList = [];
    translationMap = new Map();
    _nameController = TextEditingController(text: null);
    _descriptionController = TextEditingController(text: null);
    _msdController = TextEditingController(text: null);
    fetchDataFuture = fetchData(); // Call the API only once
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStringProvider = Provider.of<AppLanguageProvider>(context, listen: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _msdController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    activityId = widget.activity.activityId.toString();
    Timer(Duration(microseconds: 20), () {
      final getActivityDetailsViewmodel =
          Provider.of<GetActivityDetailsViewmodel>(context, listen: false);

      getActivityDetailsViewmodel.fetchGetActivityDetailsApi(
          activityId.toString(), token.toString(),currentAppLanguage);

      final languageListViewmodel =
          Provider.of<LanguageListViewmodel>(context, listen: false);

      languageListViewmodel.fetchLanguageListApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final getActivityDetailsViewmodel =
        Provider.of<GetActivityDetailsViewmodel>(context, listen: false);
    final languageListViewmodel = Provider.of<LanguageListViewmodel>(context);
    final updateActivityViewModel =
        Provider.of<UpdateActivityViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                getActivityDetailsViewmodel.setIsImageRequired(false);
                Navigator.of(context).pop();
              }),
          backgroundColor: appPrimaryColor,
          titleSpacing: 0,
          title: Text(
            AppString.get(context).updateActivity(),
            style: TextStyle(fontSize: headerFontSize, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => {fetchDataFuture = fetchData()},
            )
          ],
        ),
        floatingActionButton: canUpdate
            ? FloatingActionButton(
                onPressed: () {
                  updateActivityViewModel.setdataLoading(true);

                  Map data = {
                    "activityName": _nameController.text.toString(),
                    "activityDescription":
                        _descriptionController.text.toString(),
                    "maxSkipTimeoutDays": _msdController.text.toString(),
                    "active": activityEnabled ? "1" : "0",
                    "isImageRequired": isImageRequired ? "1" : "0",
                  };
                  print(widget.activity.activityId.toString());
                  updateActivityViewModel.updateActivityApi(
                      widget.activity.activityId.toString(),
                      token.toString(),
                      data,
                      context);
                },
                backgroundColor: appSecondaryColor,
                mini: true,
                child: Icon(Icons.done),
              )
            : Container(
                width: 0,
                height: 0,
              ),
        body: updateActivityViewModel.dataLoading == false
            ? FutureBuilder<void>(
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
                    return ChangeNotifierProvider<
                        GetActivityDetailsViewmodel>.value(
                      value: getActivityDetailsViewmodel,
                      child: Consumer<GetActivityDetailsViewmodel>(
                        builder: (context, value, _) {
                          switch (value.geActivityDetails.status!) {
                            case Status.LOADING:
                              return Center(child: CircularProgressIndicator());

                            case Status.ERROR:
                              if (value.geActivityDetails.message ==
                                  "No Internet Connection") {
                                return ErrorScreenWidget(
                                  onRefresh: () async {
                                    fetchData();
                                  },
                                  loadingText: value.geActivityDetails.message
                                      .toString(),
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
                              ActivityDetail? activity =
                                  value.geActivityDetails.data!.data!;
                              if (!getActivityDetailsViewmodel
                                  .isImageRequired) {
                                _nameController.text =
                                    activity.activityName.toString();
                                _descriptionController.text =
                                    activity.activityDescription.toString();
                                _msdController.text =
                                    activity.maxSkipTimeoutDays.toString();
                                isImageRequired =
                                    (activity.isImageRequired! > 0);
                                getActivityDetailsViewmodel
                                    .setIsImageRequired(true);
                              }

                              enableEditingForEnglish =
                                  appStringProvider.getCurrentAppLanguage ==
                                      'eng';

                              return ChangeNotifierProvider<
                                  LanguageListViewmodel>.value(
                                value: languageListViewmodel,
                                child: Consumer<LanguageListViewmodel>(
                                  builder: (context, value, _) {
                                    switch (value.languageListDetails.status!) {
                                      case Status.LOADING:
                                        return Center(
                                            child: CircularProgressIndicator());

                                      case Status.ERROR:
                                        if (value.languageListDetails.message ==
                                            "No Internet Connection") {
                                          return ErrorScreenWidget(
                                            onRefresh: () async {
                                              fetchData();
                                            },
                                            loadingText: value
                                                .languageListDetails.message
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
                                        langList!.clear();
                                        langList!.addAll(languageListViewmodel
                                            .languageListDetails.data!.data!);
                                        translationMap!.clear();

                                        langList!.forEach((element) {
                                          var translation;
                                          if (activity.translation == null) {
                                            translation = ActivityTranslation();
                                          } else {
                                            var tObj = activity.translation![
                                                element.languageCode];
                                            if (tObj != null) {
                                              translation =
                                                  ActivityTranslation.fromJson(
                                                      tObj);
                                            } else {
                                              translation =
                                                  ActivityTranslation();
                                            }
                                          }

                                          translation.languageCode =
                                              element.languageCode;
                                          translationMap![element.languageCode
                                              .toString()] = translation;
                                        });

                                        return widgetBody(context);
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
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget getMainDetailView() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
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
                    IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Util.showSnackMessage(
                              context,
                              AppString.get(context)
                                  .activityMainDetailEditInEnglishOnly());
                        }),
                    Switch(
                        value: activityEnabled,
                        onChanged: (enabled) => enableDisableActivity(enabled)),
                  ],
                ),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  enabled: activityEnabled & enableEditingForEnglish,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppString.get(context).activity(),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  enabled: activityEnabled & enableEditingForEnglish,
                  decoration: InputDecoration(
                      labelText: AppString.get(context).description()),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _msdController,
                  keyboardType: TextInputType.number,
                  enabled: activityEnabled,
                  decoration: InputDecoration(
                      labelText: AppString.get(context).maxSkipTimeoutDays()),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isImageRequired,
                      onChanged: (value) {
                        setState(() {
                          isImageRequired = value!;
                        });
                      },
                    ),
                    Text(
                      AppString.get(context).imageRequired(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTranslationsView() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (var iteration in langList!)
          _ActivityTranslationView(
            widget.activity.activityId!,
            iteration,
            translationMap!,
            updateParentWidget,
            canUpdate: canUpdate,
          )
      ],
    ));
  }

  void updateParentWidget(String v) {
    requestRefresh();
  }

  void enableDisableActivity(bool enabled) {
    setState(() {
      activityEnabled = enabled;
    });
  }

  void requestRefresh() {}

  Widget widgetFAB(BuildContext context) {
    return _FABAddUpdateActivity(
      nameController: _nameController,
      descriptionController: _descriptionController,
      msdController: _msdController,
      activityId: widget.activity.activityId!.toInt(),
      active: activityEnabled,
      isImageRequired: isImageRequired,
      canUpdate: canUpdate,
      // networkApi: networkApi,
    );
  }

  Widget widgetBody(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              getMainDetailView(),
              getTranslationsView(),
              SizedBox(
                height: 86,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isImageRequired = Provider.of<ImageState>(context).isImageRequired;

    return Checkbox(
      value: isImageRequired,
      onChanged: (value) {
        Provider.of<ImageState>(context, listen: false)
            .setImageRequired(value ?? false);
        print("isImageRequired");
        print(value);
      },
    );
  }
}

class _FABAddUpdateActivity extends StatefulWidget {
  final TextEditingController nameController,
      descriptionController,
      msdController;
  final num? activityId;
  final bool? active;
  final bool isImageRequired;
  final bool canUpdate;
  // final NetworkApi networkApi;

  _FABAddUpdateActivity({
    this.activityId,
    this.active,
    required this.nameController,
    required this.descriptionController,
    required this.msdController,
    required this.isImageRequired,
    required this.canUpdate,
    // required this.networkApi,
  });

  @override
  State createState() => _FABAddUpdateActivityState();
}

class _FABAddUpdateActivityState extends State<_FABAddUpdateActivity> {
  void addNewActivity() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Util.getAlertDialog(context, AppString.get(context).confirm(),
            AppString.get(context).updateActivity(),
            negativeText: AppString.get(context).cancel(),
            positiveText: AppString.get(context).update(),
            positiveButton: () => {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return Util.getProgressDialog(context);
                      }),
                });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.canUpdate
        ? FloatingActionButton(
            onPressed: addNewActivity,
            mini: true,
            child: Icon(Icons.done),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }
}

class _ActivityTranslationView extends StatefulWidget {
  final Language language;
  final Map<String, ActivityTranslation> translationMap;
  final num activityId;
  final ValueChanged<String> updateParentWidget;
  final bool canUpdate;
  // final NetworkApi networkApi;

  _ActivityTranslationView(
    this.activityId,
    this.language,
    this.translationMap,
    this.updateParentWidget, {
    Key? key,
    required this.canUpdate,
    // @required this.networkApi,
  }) : super(key: key);

  @override
  State createState() => _ActivityTranslationViewState();
}

class _ActivityTranslationViewState extends State<_ActivityTranslationView> {
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

  List<Widget> editModeCardContextMenu() {
    return [
      IconButton(
        icon: Icon(Icons.cancel, color: Colors.black),
        onPressed: () {
          cancelEditMode();
        },
      ),
      IconButton(
        icon: Icon(Icons.done, color: Colors.black),
        onPressed: () {
          final addUpdateActivityTranslationViewModel =
              Provider.of<AddUpdateActivityTranslationViewModel>(context,
                  listen: false);
          Map data = {
            'language': widget
                .translationMap[widget.language.languageCode]!.languageCode,
            'translation': nameCtr.text.toString(),
            'description': descCtr.text.toString(),
          };
          addUpdateActivityTranslationViewModel.addUpdateActivityTranslationApi(
              widget.activityId.toString(), token.toString(), data, context);
        },
      )
    ];
  }

  void cancelEditMode() {}

  void _reInitAddFuture() {}

  void _reInitEditFuture() {}

  @override
  Widget build(BuildContext context) {
    return _hasTranslation ? getTranslationView() : getTranslationView();
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
                      // startEditMode();
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
                      labelText: AppString.get(context).activity()),
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
                      labelText: AppString.get(context).description()),
                  enabled: editButton,
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
}
