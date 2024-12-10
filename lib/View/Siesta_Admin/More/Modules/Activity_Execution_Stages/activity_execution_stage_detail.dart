import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/More_Model/activityExecution_stages_model.dart';
import 'package:siestaamsapp/Model/More_Model/activity_execution_stage_details_model.dart';
import 'package:siestaamsapp/Model/More_Model/languageList_model.dart';
import 'package:siestaamsapp/Provider/app_language_provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activities/activity_translation.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/activity_execution_stage_detail_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/addUpdateActivityExecutionStagesTranslations_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Authentication_Roles_View_Model/languageList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class ActivityExecutionStageDetailPage extends StatefulWidget {
  final ActivityExecutionStage activityExecutionStage;

  const ActivityExecutionStageDetailPage(
      {super.key, required this.activityExecutionStage});

  @override
  State<ActivityExecutionStageDetailPage> createState() =>
      _ActivityExecutionStageDetailPageState();
}

class _ActivityExecutionStageDetailPageState
    extends State<ActivityExecutionStageDetailPage> {
  bool? autoRemoveByScheduler;
  late ActivityExecutionStageDetails edited;
  late AppLanguageProvider appStringProvider;
  late List<Language> langList;
  late Map<String, ActivityTranslation> translationMap;
  String? stageCode;
  dynamic _errorActivity;
  late AuthModal authModal;
  bool? canUpdate;
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  List<TextEditingController> nameCtrList = [];
  List<TextEditingController> descCtrList = [];
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


    fetchDataFuture = fetchData(); // Call the API only once

    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleActivity);
    langList = [];
    translationMap = new Map();
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final activityExecutionStageDetailsViewmodel =
          Provider.of<ActivityExecutionStageDetailsViewmodel>(context,
              listen: false);
      activityExecutionStageDetailsViewmodel
          .fetchActivityExecutionStageDetailsApi(
              widget.activityExecutionStage.stageCode.toString(),
              token.toString(),currentAppLanguage);

      final languageListViewmodel =
          Provider.of<LanguageListViewmodel>(context, listen: false);

      languageListViewmodel.fetchLanguageListApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final activityExecutionStageDetailsViewmodel =
        Provider.of<ActivityExecutionStageDetailsViewmodel>(context);
    final languageListViewmodel = Provider.of<LanguageListViewmodel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: appPrimaryColor,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.activityExecutionStage.stageName.toString(),
                style: TextStyle(fontSize: headerFontSize, color: Colors.white),
              ),
              Text(
                '${AppString.get(context).stageCode()}: ${widget.activityExecutionStage.stageCode}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () => {fetchDataFuture = fetchData()},
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: false,
            tabs: [
              Tab(
                child: Text(
                  AppString.get(context).detail(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  AppString.get(context).translation(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
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
              // Render the UI with the fetched data
              return ChangeNotifierProvider<
                  ActivityExecutionStageDetailsViewmodel>.value(
                value: activityExecutionStageDetailsViewmodel,
                child: Consumer<ActivityExecutionStageDetailsViewmodel>(
                  builder: (context, value, _) {
                    switch (value.activityExecutionStagesList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                      case Status.ERROR:
                        if (value.activityExecutionStagesList.message ==
                            "No Internet Connection") {
                          return ErrorScreenWidget(
                            onRefresh: () async {
                              fetchData();
                            },
                            loadingText: value
                                .activityExecutionStagesList.message
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
                                  edited =
                                      activityExecutionStageDetailsViewmodel
                                          .activityExecutionStagesList
                                          .data!
                                          .data!;
                                  autoRemoveByScheduler =
                                      (edited.autoRemoveByScheduler! > 0);

                                  langList.clear();
                                  langList.addAll(languageListViewmodel
                                      .languageListDetails.data!.data!);
                                  translationMap.clear();

                                  langList.forEach((element) {
                                    var translation;
                                    if (edited.translation == null) {
                                      translation = ActivityTranslation();
                                    } else {
                                      var tObj = edited
                                          .translation[element.languageCode];
                                      if (tObj != null) {
                                        translation =
                                            ActivityTranslation.fromJson(tObj);
                                      } else {
                                        translation = ActivityTranslation();
                                      }
                                    }

                                    translation.languageCode =
                                        element.languageCode;
                                    translationMap[element.languageCode
                                        .toString()] = translation;
                                  });

                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: TabBarView(children: [
                                      getMainDetailView(),
                                      getTranslationsView(),
                                    ]),
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

  Widget getMainDetailView() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${AppString.get(context).stageName()}: ${edited.stageNameTranslation ?? edited.stageName}',
                    style: TextStyle(
                      fontSize: headerFontSize,
                      //  fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    '${AppString.get(context).stageCode()}: ${edited.stageCode}',
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: autoRemoveByScheduler,
                        onChanged: null,
                      ),
                      Text(
                        AppString.get(context).autoRemovableByScheduler(),
                        style: TextStyle(fontSize: descriptionFontSize),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTranslationsView() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (var iteration in langList)
              _ActivityExecStageTranslationView(
                stageCode: widget.activityExecutionStage.stageCode.toString(),
                language: iteration,
                translationMap: translationMap,
                updateParentWidget: updateParentWidget,
                canUpdate: canUpdate!,
              )
          ],
        ),
      ),
    );
  }

  void updateParentWidget(String v) {}

  List<Widget> editModeCardContextMenu() {
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          setState(() {
            editButton = false;
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.done, color: Colors.black),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => YourWidget()));

          // YourWidget();
          // startAddUpdateTranslationMode();

          // final addUpdateActivityExecutionStagesTranslationViewModel =
          //     Provider.of<AddUpdateActivityExecutionStagesTranslationViewModel>(
          //         context,
          //         listen: false);
          // Map data = {
          //   'stageCode': widget.stageCode.toString(),
          //   'language': nameCtr.text.toString(),
          //   'translation': widget
          //       .translationMap[widget.language.languageCode]?.languageCode
          //       .toString(),
          //   'description': descCtrList[index].text.toString(),
          // };
          // addUpdateActivityExecutionStagesTranslationViewModel
          //     .addUpdateActivityExecutionStagesTranslationApi(
          //         token.toString(), data, context);

          // _reInitEditFuture();
        },
      )
    ];
  }
}

class _ActivityExecStageTranslationView extends StatefulWidget {
  final Language language;
  final Map<String, ActivityTranslation> translationMap;
  final String stageCode;
  final ValueChanged<String> updateParentWidget;
  final bool canUpdate;

  _ActivityExecStageTranslationView({
    Key? key,
    required this.canUpdate,
    required this.stageCode,
    required this.language,
    required this.translationMap,
    required this.updateParentWidget,
  }) : super(key: key);

  @override
  State createState() => _ActivityExecStageTranslationViewState();
}

class _ActivityExecStageTranslationViewState
    extends State<_ActivityExecStageTranslationView> {
  final nameCtr = TextEditingController();
  final descCtr = TextEditingController();
  bool _hasTranslation = false;
  late ActivityTranslation _translation;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  bool editButton = false;

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
          setState(() {
            editButton = false;
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.done, color: Colors.black),
        onPressed: () {
          final addUpdateActivityExecutionStagesTranslationViewModel =
              Provider.of<AddUpdateActivityExecutionStagesTranslationViewModel>(
                  context,
                  listen: false);
          Map data = {
            'stageCode': widget.stageCode.toString(),
            'language': widget
                .translationMap[widget.language.languageCode]!.languageCode
                .toString(),
            'translation': nameCtr.text.toString(),
            'description': descCtr.text.toString(),
          };
          addUpdateActivityExecutionStagesTranslationViewModel
              .addUpdateActivityExecutionStagesTranslationApi(
                  token.toString(), data, context);
        },
      )
    ];
  }

  void cancelEditMode() {
    setState(() {
      // _formPageState = Util.FormPageState.IDLE;
    });
  }

  void startEditMode() {
    setState(() {
      // _formPageState = Util.FormPageState.EDIT;
    });
  }

  void startAddUpdateTranslationMode() {
    setState(() {
      // _formPageState = Util.FormPageState.PROGRESS;
    });
  }

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
                              widget.language.name!,
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
                    labelText: AppString.get(context).stage(),
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
                      labelText: AppString.get(context).description()),
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
