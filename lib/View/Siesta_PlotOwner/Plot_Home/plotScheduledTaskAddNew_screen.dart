import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Utils;

import '../../../Data/Response/status.dart';
import '../../../Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import '../../../Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import '../../../Model/Dashboard_model/AddTask_Model/getAssetsList_model.dart';
import '../../../Model/Report_Model/activity_groups.dart';
import '../../../Provider/app_language_provider.dart';
import '../../../Res/colors.dart';
import '../../../Utils/Routes/routes_name.dart';
import '../../../Utils/Widgets/errorScreen_widget.dart';
import '../../../Utils/utils.dart';
import '../../../View_Model/Dashboard_View_Model/AddTask_View_Model/addNotifiedTaskManually_view_model.dart';
import '../../../View_Model/Dashboard_View_Model/AddTask_View_Model/addScheduledTaskManually_view_model.dart';
import '../../../View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitiesList_view_model.dart';
import '../../../View_Model/Dashboard_View_Model/AddTask_View_Model/getAssetsList_view_model.dart';
import '../../../View_Model/PlotOwner_View_Model/getPlotOwnerActivity_schedulersList_view_model.dart';
import '../../../View_Model/PlotOwner_View_Model/getPlotOwnerAssetsList_view_model.dart';
import '../../../View_Model/Report_View_Model/activityGroups_view_model.dart';
import '../../../constants/string_res.dart';
import '../../SharedPreferences/sharePreference.dart';
import '../../Siesta_Admin/Dashboard/list_item.dart';
import '../../Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';

class PlotScheduledTaskAddNewPage extends StatefulWidget {
  const PlotScheduledTaskAddNewPage({super.key});

  @override
  State<PlotScheduledTaskAddNewPage> createState() => _PlotScheduledTaskAddNewPageState();
}

class _PlotScheduledTaskAddNewPageState extends State<PlotScheduledTaskAddNewPage> {
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
            AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);

        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();

    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getPlotOwnerActivitySchedulersListViewmodel =
          Provider.of<GetPlotOwnerActivitySchedulersListViewmodel>(context,
              listen: false);

      getPlotOwnerActivitySchedulersListViewmodel
          .fetchGetPlotOwnerActivitySchedulersListApi(token.toString(),currentAppLanguage);

      final getPlotOwnerAssetsListViewmodel =
          Provider.of<GetPlotOwnerAssetsListViewmodel>(context, listen: false);

      getPlotOwnerAssetsListViewmodel.fetchGetPlotOwnerAssetsListApi(token.toString(),currentAppLanguage);
      final getActivitiesListViewmodel =
          Provider.of<GetActivitiesListViewmodel>(context, listen: false);
      getActivitiesListViewmodel.fetchGetActivitiesListApi(token.toString(),currentAppLanguage);
      final activityGroupsViewmodel =
          Provider.of<ActivityGroupsViewmodel>(context, listen: false);
      activityGroupsViewmodel.fetchActivityGroupsApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            '${AppString.get(context).add()}',
            style: TextStyle(fontSize: headerFontSize, color: Colors.white),
          ),
          titleSpacing: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                try {
                  fetchData();
                } catch (e) {
                  print(e);
                }
                try {
                  fetchData();
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: AppString.get(context).activity()),
              Tab(text: AppString.get(context).notified()),
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
              return TabBarView(
                children: [
                  ScheduledTaskAddNewBody(),
                  NotifiedActivityAddNew(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ScheduledTaskAddNewBody extends StatefulWidget {
  ScheduledTaskAddNewBody({Key? key}) : super(key: key);

  @override
  _ScheduledTaskAddNewBodyState createState() {
    return _ScheduledTaskAddNewBodyState();
  }
}

class _ScheduledTaskAddNewBodyState extends State<ScheduledTaskAddNewBody> {
  String? token;
  List<ExpansionEntry> _expandedItems = [];
  Map<String, List<ActivitySchedulers>> map = {};
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;

  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();

      });
    });
    super.initState();
    _reloadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPlotOwnerActivitySchedulersListViewmodel =
        Provider.of<GetPlotOwnerActivitySchedulersListViewmodel>(context);

    return ChangeNotifierProvider<GetPlotOwnerActivitySchedulersListViewmodel>.value(
      value: getPlotOwnerActivitySchedulersListViewmodel,
      child: Consumer<GetPlotOwnerActivitySchedulersListViewmodel>(
        builder: (context, value, _) {
          switch (value.getPlotOwnerActivitySchedulersList.status!) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());

            case Status.ERROR:
              if (value.getPlotOwnerActivitySchedulersList.message ==
                  "No Internet Connection") {
                return ErrorScreenWidget(
                  onRefresh: () async {},
                  loadingText:
                      value.getPlotOwnerActivitySchedulersList.message.toString(),
                );
              } else {
                return Center(
                  child:
                      Text(value.getPlotOwnerActivitySchedulersList.message.toString()),
                );
              }

            case Status.COMPLETED:
              List<ActivitySchedulers>? list =
                  value.getPlotOwnerActivitySchedulersList.data!.data!;
              resetExpandedList(context, list: list);
              if (map.isEmpty) {
                return Utils.getEmptyDataView(context,
                    callback: () => _reloadData());
              }
              return Container(
                color: Colors.grey.shade200,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  itemCount: map.keys.length,
                  itemBuilder: (context, index) {
                    String key = map.keys.elementAt(index);
                    List<ActivitySchedulers> children = map[key]!;
                    List<ExpansionEntry> tempChildrenList = [];
                    children.forEach(
                      (value) {
                        tempChildrenList.add(
                          ExpansionEntry(
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      value.activityNameTranslation.toString(),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Confirm',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  // fontWeight:
                                                  //     FontWeight.bold
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure want to schedule the task?',
                                                style:
                                                    TextStyle(fontSize: 12.sp),
                                                // textAlign: TextAlign.center,
                                              ),
                                              actions: <Widget>[
                                                SizedBox(
                                                  child: TextButton(
                                                    child: Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color:
                                                              appSecondaryColor),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: TextButton(
                                                    child: Text(
                                                      'YES',
                                                      style: TextStyle(
                                                        color:
                                                            appSecondaryColor,
                                                        fontSize: 13.sp,
                                                        // fontWeight:
                                                        //     FontWeight.bold
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _addActivityToTasks(
                                                          value);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Chip(
                                        avatar: Icon(Icons.add,
                                            color: Colors.white),
                                        backgroundColor: appSecondaryColor,
                                        label: Text(
                                          AppString.get(context).add(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    return Card(
                      child: ExpandedItem(
                        ExpansionEntry(
                          Container(
                            child: Text(key,
                                style: TextStyle(fontSize: titleFontSize)),
                          ),
                          children: tempChildrenList,
                        ),
                        initiallyExpanded: true,
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _reloadData() {}

  void resetExpandedList(BuildContext context,
      {List<ActivitySchedulers>? list}) {
    _expandedItems.clear();
    map.clear();
    if (list != null) {
      list.forEach(
        (value) {
          String key = value.propertyNameTranslation?.toUpperCase() ??
              value.propertyName?.toUpperCase() ??
              value.propertyNumber!.toUpperCase();
          if (map.containsKey(key)) {
            List<ActivitySchedulers> list = map[key] ?? [];
            list.add(value);
            list.sort((a1, a2) {
              if (a1.activityName == null && a2.activityName == null) return 0;
              if (a2.activityName == null) return 1;
              if (a1.activityName == null) return -1;
              return a1.activityName!.compareTo(a2.activityName.toString());
            });
            map[key] = list;
          } else {
            List<ActivitySchedulers> list = [value];
            list.sort((a1, a2) {
              if (a1.activityName == null && a2.activityName == null) return 0;
              if (a2.activityName == null) return 1;
              if (a1.activityName == null) return -1;
              return a1.activityName!.compareTo(a2.activityName.toString());
            });
            map.putIfAbsent(
              key,
              () {
                return list;
              },
            );
          }
        },
      );
    }
  }

  void _addActivityToTasks(ActivitySchedulers activity) {
    final addScheduledTaskManuallyViewModel =
        Provider.of<AddScheduledTaskManuallyViewModel>(context, listen: false);

    Map data = {
      "schedulerId": activity.schedulerId.toString(),
      'comments': '',
    };
    print('addaddaddaddaddadd');
    addScheduledTaskManuallyViewModel.addScheduledTaskManuallyApi(
        token.toString(), data, context);
  }
}

class NotifiedActivityAddNew extends StatefulWidget {
  NotifiedActivityAddNew({Key? key}) : super(key: key);

  @override
  _NotifiedActivityAddNewState createState() {
    return _NotifiedActivityAddNewState();
  }
}

class _NotifiedActivityAddNewState extends State<NotifiedActivityAddNew> {
  // Utils.PageStatus _pageStatus = Utils.PageStatus.IDLE;
  dynamic _errorPageStatus;
  Assets? _currentProperty;
  Activities? _currentActivity;
  ActivityGroups? _currentActivityGroup;
  List<File>? _filesList;
  List<Assets>? _propertyList;
  late List<Activities> _activityList;
  List<ActivityGroups>? _activityGroupsList;
  late TextEditingController _commentController, _dateController;
  DateTime? _tentDeadline;
  String? token;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;

  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();
      });
    });
    super.initState();
    _filesList = [];
    _propertyList = [];
    _activityList = [];
    _activityGroupsList = [];
    _tentDeadline = DateTime.now();
    _commentController = TextEditingController();
    _dateController = TextEditingController(text: getDeadlineString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    _commentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPlotOwnerAssetsListViewmodel = Provider.of<GetPlotOwnerAssetsListViewmodel>(context);
    final getActivitiesListViewmodel =
        Provider.of<GetActivitiesListViewmodel>(context);
    final activityGroupsViewmodel =
        Provider.of<ActivityGroupsViewmodel>(context);
    return ChangeNotifierProvider<GetActivitiesListViewmodel>.value(
      value: getActivitiesListViewmodel,
      child: Consumer<GetActivitiesListViewmodel>(
        builder: (context, value, _) {
          switch (value.getActivitiesList.status!) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());

            case Status.ERROR:
              if (value.getActivitiesList.message == "No Internet Connection") {
                return ErrorScreenWidget(
                  onRefresh: () async {},
                  loadingText: value.getActivitiesList.message.toString(),
                );
              } else {
                return Center(
                  child: Text(value.getActivitiesList.message.toString()),
                );
              }

            case Status.COMPLETED:
              return 
              
              
              
              
              ChangeNotifierProvider<GetPlotOwnerAssetsListViewmodel>.value(
                value: getPlotOwnerAssetsListViewmodel,
                child: Consumer<GetPlotOwnerAssetsListViewmodel>(
                  builder: (context, value, _) {
                    switch (value.getPlotOwnerAssetsList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        if (value.getPlotOwnerAssetsList.message ==
                            "No Internet Connection") {
                          // If no internet connection, show error screen
                          return ErrorScreenWidget(
                            onRefresh: () async {},
                            loadingText: value.getPlotOwnerAssetsList.message.toString(),
                          );
                        } else {
                          return Center(
                            child: Text(value.getPlotOwnerAssetsList.message.toString()),
                          );
                        }

                      case Status.COMPLETED:
                        return  ChangeNotifierProvider<
                            ActivityGroupsViewmodel>.value(
                          value: activityGroupsViewmodel,
                          child: Consumer<ActivityGroupsViewmodel>(
                            builder: (context, value, _) {
                              switch (value.activityGroupsList.status!) {
                                case Status.LOADING:
                                  return Center(
                                      child: CircularProgressIndicator());

                                case Status.ERROR:
                                  if (value.activityGroupsList.message ==
                                      "No Internet Connection") {
                                    return ErrorScreenWidget(
                                      onRefresh: () async {},
                                      loadingText: value
                                          .activityGroupsList.message
                                          .toString(),
                                    );
                                  } else {
                                    return Center(
                                      child: Text(value
                                          .activityGroupsList.message
                                          .toString()),
                                    );
                                  }

                                case Status.COMPLETED:
                                  _activityList.clear();
                                  List<Activities> list =
                                      getActivitiesListViewmodel
                                          .getActivitiesList.data!.data!;
                                  _activityList.addAll(list);
                                  if (_currentActivity == null &&
                                      list.length > 0) {
                                    _currentActivity = list[0];
                                  }
                                  _propertyList!.clear();
                                  List<Assets> list1 = getPlotOwnerAssetsListViewmodel
                                      .getPlotOwnerAssetsList.data!.data!;
                                  _propertyList!.addAll(list1);
                                  if (_currentProperty == null &&
                                      list.length > 0) {
                                    _currentProperty = list1[0];
                                  }
                                  _activityGroupsList!.clear();
                                  List<ActivityGroups> list2 =
                                      activityGroupsViewmodel
                                          .activityGroupsList.data!.data!;
                                  _activityGroupsList!.addAll(list2);
                                  if (_currentActivityGroup == null &&
                                      list.length > 0) {
                                    _currentActivityGroup = list2[0];
                                  }
                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    color: Colors.grey.shade200,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          widgetPlotSelection(),
                                          SizedBox(height: 8),
                                          widgetActivitySelection(),
                                          SizedBox(height: 8),
                                          widgetPrioritySelection(),
                                          SizedBox(height: 8),
                                          widgetDeadlineSelection(),
                                          SizedBox(height: 8),
                                          widgetComment(),
                                          SizedBox(height: 8),
                                          if (Platform.isAndroid)
                                            widgetPhotos(),
                                          if (Platform.isAndroid)
                                            SizedBox(height: 8),
                                          widgetAddButton(),
                                        ],
                                      ),
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

  String getDeadlineString() {
    DateTime local = _tentDeadline!.toLocal();
    return DateFormat('dd-MMM-yyyy').format(local);
  }

  void openDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _tentDeadline!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 10000)),
    ).then((value) {
      if (value == null) {
        print('null value called');
        return;
      }
      setState(() {
        _tentDeadline = value;
      });
      _dateController.text = getDeadlineString();
    });
  }

  Future<void> addNotifiedTask() async {
    if (_currentProperty == null) {
      Utils.showSnackMessage(context, 'Select Asset/Plot again');
      return;
    }
    if (_currentActivity == null) {
      Utils.showSnackMessage(context, 'Select Activity again');
      return;
    }
    if (_currentActivityGroup == null) {
      Utils.showSnackMessage(context, 'Select ActivityGroup again');
      return;
    }
    if (_tentDeadline == null) {
      Utils.showSnackMessage(context, 'Select Tentative Deadline again');
      return;
    }

    final addNotifiedTaskManuallyViewModel =
        Provider.of<AddNotifiedTaskManuallyViewModel>(context, listen: false);
    var localDate = _tentDeadline!.toLocal();
    final reqBody = new dio.FormData.fromMap({
      "activityId": _currentActivity!.activityId!.toString(),
      'assetId': _currentProperty!.id!.toString(),
      'tentDeadline':
          '${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}',
      'comments': _commentController.text.toString(),
      'activityGroup': _currentActivityGroup?.code.toString(),
      ' ': 'notified_activity',
      'moduleId':
          '${_currentActivity?.activityId?.toInt()}_${_currentProperty?.id?.toString()}',
      'moduleStatus': 'active',
    });
    _filesList?.forEach((element) {
      reqBody.files.add(
        MapEntry(
          'images',
          dio.MultipartFile.fromFileSync(element.path),
        ),
      );
    });

    addNotifiedTaskManuallyViewModel.addNotifiedTaskManuallyApi(
        token.toString(), reqBody, context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Utils.getProgressDialog(context),
    );
  }

  void showImagePicker(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.cameraScreen).then((value) {
      if (value == null || value is! List || (value as List).length <= 0) {
        return;
      }
      if ((value as List).length > 10) {
        Utils.showSnackMessage(context, 'Maximum upload files: 10');
        return;
      }
      List<ListItem<File>> list = value as dynamic;
      List<File> files = [];
      list.forEach((element) {
        if (element.isSelected) {
          files.add(element.data);
        }
      });

      setState(() {
        _filesList!.addAll(files);
      });
    }).catchError((error) {
      Utils.showSnackMessage(context, error.toString());
    });
  }

  Widget widgetPlotSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${AppString.get(context).assets()} / ${AppString.get(context).plot()}',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<Assets>(
                value: _currentProperty,
                underline: Container(),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _currentProperty = value;
                  });
                },
                items: _propertyList!
                    .map(
                      (e) => DropdownMenuItem<Assets>(
                        value: e,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Text(
                              e.propertyNameTranslation ??
                                  e.propertyName ??
                                  e.propertyNumber!,
                            ),
                          ),
                        ),
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

  Widget widgetActivitySelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${AppString.get(context).notifiedActivity()}',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<Activities>(
                value: _currentActivity,
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    _currentActivity = value;
                  });
                },
                isExpanded: true,
                items: _activityList
                    .map(
                      (e) => DropdownMenuItem<Activities>(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              e.activityNameTranslation ?? e.activityName!),
                        ),
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

  Widget widgetPrioritySelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${AppString.get(context).groupPriority()}',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<ActivityGroups>(
                value: _currentActivityGroup,
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    _currentActivityGroup = value;
                  });
                },
                isExpanded: true,
                items: _activityGroupsList!
                    .map(
                      (e) => DropdownMenuItem<ActivityGroups>(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('P${e.priority} - ${e.name}'),
                        ),
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

  Widget widgetDeadlineSelection() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: AppString.get(context).tentativeDeadline(),
            labelText: AppString.get(context).tentativeDeadline(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          readOnly: true,
          onTap: () => openDatePicker(),
          controller: _dateController,
        ),
      ),
    );
  }

  Widget widgetComment() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: AppString.get(context).comment(),
            labelText: AppString.get(context).comment(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          controller: _commentController,
        ),
      ),
    );
  }

  Widget widgetPhotos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.get(context).images(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextButton(
                  child: Text(
                    AppString.get(context).clearAll(),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: appSecondaryColor),
                  ),
                  onPressed: () {
                    setState(() {
                      _filesList!.clear();
                    });
                  },
                )
              ],
            ),
            GridView.builder(
              itemCount: _filesList!.length + 1,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _filesList!.length == 0 ? 1 : 3,
                childAspectRatio: _filesList!.length == 0 ? 1.8 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (index == 0)
                  return Container(
                    decoration: BoxDecoration(
                      color: _filesList!.length == 0
                          ? Colors.grey.shade300
                          : Colors.grey.shade400,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // showImagePickingOptions(context);
                          showImagePicker(context);
                        },
                        child: Center(
                          child: _filesList!.length == 0
                              ? Container(
                                  padding: EdgeInsets.all(32),
                                  child: SvgPicture.asset(
                                    'asset/images/photo.svg',
                                  ),
                                )
                              : Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 40,
                                ),
                        ),
                      ),
                    ),
                  );
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: Stack(
                    children: [
                      Image.file(
                        _filesList![index - 1],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              _filesList!.removeAt(index - 1);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetAddButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => addNotifiedTask(),
        style: ElevatedButton.styleFrom(
          backgroundColor: appSecondaryColor,
          foregroundColor: appSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          AppString.get(context).submit(),
          style:
              Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
