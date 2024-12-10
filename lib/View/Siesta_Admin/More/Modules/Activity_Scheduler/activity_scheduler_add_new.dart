import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Custom/custom_views.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/selectable_day.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import 'package:siestaamsapp/Model/More_Model/activitySchedulerParamsList_model.dart';
import 'package:siestaamsapp/Model/More_Model/schedulerPendingItemList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitiesList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/activitySchedulerParamsList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/addNewActivitySchedulers_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/schedulerPendingActivityItemList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/schedulerPendingItemList_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class ActivitySchedulerAddNewPage extends StatefulWidget {
  final ActivitySchedulers? activity;

  const ActivitySchedulerAddNewPage({super.key, required this.activity});

  @override
  State<ActivitySchedulerAddNewPage> createState() =>
      _ActivitySchedulerAddNewPageState();
}

class _ActivitySchedulerAddNewPageState
    extends State<ActivitySchedulerAddNewPage> {
  bool showFab = false;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  List<Activities> activitiesList = [];
  List<SchedulerParams> schedulerParamsList = [];

  List<Property> propertyList = [];
  Property? _currentProperty;
  Map<num, Activities> activitiesWidgetsMap = {};
  late Future<void> fetchDataFuture;

  List<DropdownMenuItem<Property>> plList = [];
    late String currentAppLanguage;

  dynamic errorProperty, errorActivity;
  @override
  void initState() {
    userPreference.getUserData().then((value) {
      setState(() {
        UserData = value!;
        token = UserData['data']['accessToken'].toString();
      });
    });
    super.initState();
    if (widget.activity != null) {
      propertyList = [
        Property(
          id: widget.activity!.propertyId?.toInt(),
          propertyArea: widget.activity?.propertyArea,
          propertyDevStageId: widget.activity?.propertyDevStageId,
          propertyDevStageName: widget.activity?.propertyDevStageName,
          propertyNumber: widget.activity?.propertyNumber,
          propertyName: widget.activity?.propertyName,
          propertyNameTranslation: widget.activity?.propertyNameTranslation,
        )
      ];
      _currentProperty = propertyList[0];
    }

                            AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);

        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();

    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      propertyList.clear();
      activitiesList.clear();
      schedulerParamsList.clear();
      activitiesWidgetsMap.clear();
      final schedulerPendingItemListViewmodel =
          Provider.of<SchedulerPendingItemListViewmodel>(context,
              listen: false);

      schedulerPendingItemListViewmodel.fetchSchedulerPendingItemListApi(
          'property', 'null', token.toString(),currentAppLanguage);

      final getActivitiesListViewmodel =
          Provider.of<GetActivitiesListViewmodel>(context, listen: false);

      final activitySchedulerParamsListViewmodel =
          Provider.of<ActivitySchedulerParamsListViewmodel>(context,
              listen: false);

      activitySchedulerParamsListViewmodel
          .fetchActivitySchedulerParamsListApi(token.toString(),currentAppLanguage);
      final schedulerPendingActivityItemListViewmodel =
          Provider.of<SchedulerPendingActivityItemListViewmodel>(context,
              listen: false);

      if (widget.activity == null) {
        getActivitiesListViewmodel.fetchGetActivitiesListApi(token.toString(),currentAppLanguage);
      } else {
        schedulerPendingActivityItemListViewmodel
            .fetchSchedulerPendingActivityItemListApi('activity',
                widget.activity!.propertyId.toString(), token.toString(),currentAppLanguage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final schedulerPendingItemListViewmodel =
        Provider.of<SchedulerPendingItemListViewmodel>(context, listen: false);
    final getActivitiesListViewmodel =
        Provider.of<GetActivitiesListViewmodel>(context, listen: false);
    final activitySchedulerParamsListViewmodel =
        Provider.of<ActivitySchedulerParamsListViewmodel>(context,
            listen: false);
    final schedulerPendingActivityItemListViewmodel =
        Provider.of<SchedulerPendingActivityItemListViewmodel>(context,
            listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).addNewScheduler(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                fetchDataFuture = fetchData();
              });
            },
          )
        ],
      ),
      floatingActionButton: _SaveSchedulerFAB(
        activitiesWidgetsMap,
        () {
          addNewSchedulers(context);
        },
        showFab,
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
            return ChangeNotifierProvider<
                SchedulerPendingItemListViewmodel>.value(
              value: schedulerPendingItemListViewmodel,
              child: Consumer<SchedulerPendingItemListViewmodel>(
                builder: (context, value, _) {
                  switch (value.schedulerPendingItemList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      return ErrorScreenWidget(
                        onRefresh: () async {
                          fetchData();
                        },
                        loadingText:
                            value.schedulerPendingItemList.message.toString(),
                      );
                    case Status.COMPLETED:
                      _reInitPropertyFuture();
                      return widget.activity == null
                          ? ChangeNotifierProvider<
                              GetActivitiesListViewmodel>.value(
                              value: getActivitiesListViewmodel,
                              child: Consumer<GetActivitiesListViewmodel>(
                                builder: (context, value, _) {
                                  switch (value.getActivitiesList.status!) {
                                    case Status.LOADING:
                                      return Center(
                                          child: CircularProgressIndicator());

                                    case Status.ERROR:
                                      return ErrorScreenWidget(
                                        onRefresh: () async {
                                          fetchData();
                                        },
                                        loadingText: value
                                            .getActivitiesList.message
                                            .toString(),
                                      );
                                    case Status.COMPLETED:
                                      activitiesList =
                                          getActivitiesListViewmodel
                                              .getActivitiesList.data!.data!;
                                      return ChangeNotifierProvider<
                                          ActivitySchedulerParamsListViewmodel>.value(
                                        value:
                                            activitySchedulerParamsListViewmodel,
                                        child: Consumer<
                                            ActivitySchedulerParamsListViewmodel>(
                                          builder: (context, value, _) {
                                            switch (value
                                                .activitySchedulerParamsList
                                                .status!) {
                                              case Status.LOADING:
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              case Status.ERROR:
                                                return ErrorScreenWidget(
                                                  onRefresh: () async {
                                                    fetchData();
                                                  },
                                                  loadingText: value
                                                      .activitySchedulerParamsList
                                                      .message
                                                      .toString(),
                                                );
                                              case Status.COMPLETED:
                                                // _reInitActivityFuture();

                                                schedulerParamsList = value
                                                    .activitySchedulerParamsList
                                                    .data!
                                                    .data!;

                                                return Container(
                                                  color: Colors.grey.shade200,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: 64),
                                                    itemCount:
                                                        activitiesWidgetsMap
                                                                .keys.length +
                                                            2,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Widget w;
                                                      switch (index) {
                                                        case 0:
                                                          {
                                                            {
                                                              w = getPlotSelectorCard();
                                                            }
                                                            break;
                                                          }
                                                        case 1:
                                                          {
                                                            {
                                                              w = getAddActivitySchedulerCard();
                                                            }
                                                            break;
                                                          }
                                                        default:
                                                          {
                                                            {
                                                              Activities
                                                                  activity =
                                                                  activitiesWidgetsMap
                                                                          .values
                                                                          .toList()[
                                                                      index -
                                                                          2];
                                                              w = _ActivityScheduler(
                                                                  activity,
                                                                  (value) =>
                                                                      activitiesWidgetsMap
                                                                          .remove(
                                                                              value),
                                                                  schedulerParamsList,
                                                                  refreshWidget);
                                                            }
                                                            break;
                                                          }
                                                      }
                                                      return w;
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
                            )
                          : ChangeNotifierProvider<
                              SchedulerPendingActivityItemListViewmodel>.value(
                              value: schedulerPendingActivityItemListViewmodel,
                              child: Consumer<
                                  SchedulerPendingActivityItemListViewmodel>(
                                builder: (context, value, _) {
                                  switch (value.schedulerPendingActivityItemList
                                      .status!) {
                                    case Status.LOADING:
                                      return Center(
                                          child: CircularProgressIndicator());

                                    case Status.ERROR:
                                      return ErrorScreenWidget(
                                        onRefresh: () async {
                                          fetchData();
                                        },
                                        loadingText: value
                                            .schedulerPendingActivityItemList
                                            .message
                                            .toString(),
                                      );
                                    case Status.COMPLETED:
                                      // // _reInitActivityFuture();
                                      // if (widget.activity == null) {
                                      activitiesList =
                                          schedulerPendingActivityItemListViewmodel
                                              .schedulerPendingActivityItemList
                                              .data!
                                              .data!;

                                      return ChangeNotifierProvider<
                                          ActivitySchedulerParamsListViewmodel>.value(
                                        value:
                                            activitySchedulerParamsListViewmodel,
                                        child: Consumer<
                                            ActivitySchedulerParamsListViewmodel>(
                                          builder: (context, value, _) {
                                            switch (value
                                                .activitySchedulerParamsList
                                                .status!) {
                                              case Status.LOADING:
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());

                                              case Status.ERROR:
                                                return ErrorScreenWidget(
                                                  onRefresh: () async {
                                                    fetchData();
                                                  },
                                                  loadingText: value
                                                      .activitySchedulerParamsList
                                                      .message
                                                      .toString(),
                                                );
                                              case Status.COMPLETED:
                                                // _reInitActivityFuture();

                                                schedulerParamsList = value
                                                    .activitySchedulerParamsList
                                                    .data!
                                                    .data!;

                                                return Container(
                                                  color: Colors.grey.shade200,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: 64),
                                                    itemCount:
                                                        activitiesWidgetsMap
                                                                .keys.length +
                                                            2,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Widget w;
                                                      switch (index) {
                                                        case 0:
                                                          {
                                                            {
                                                              w = getPlotSelectorCard();
                                                            }
                                                            break;
                                                          }
                                                        case 1:
                                                          {
                                                            {
                                                              w = getAddActivitySchedulerCard();
                                                            }
                                                            break;
                                                          }
                                                        default:
                                                          {
                                                            {
                                                              Activities
                                                                  activity =
                                                                  activitiesWidgetsMap
                                                                          .values
                                                                          .toList()[
                                                                      index -
                                                                          2];
                                                              w = _ActivityScheduler(
                                                                  activity,
                                                                  (value) =>
                                                                      activitiesWidgetsMap
                                                                          .remove(
                                                                              value),
                                                                  schedulerParamsList,
                                                                  refreshWidget);
                                                            }
                                                            break;
                                                          }
                                                      }
                                                      return w;
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
    );
  }

  void refreshWidget() {
    setState(() {});
  }

  Widget getPlotSelectorCard() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppString.get(context).selectPlot(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 5),
            propertyList.length <= 1
                ? Text(
                    _currentProperty!.propertyNameTranslation ??
                        _currentProperty!.propertyName ??
                        propertyList[0].propertyName.toString(),
                    style: TextStyle(
                      fontSize: headerFontSize,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<Property>(
                      items: plList,
                      isExpanded: true,
                      underline: Container(),
                      value: _currentProperty,
                      onChanged: (Property? p) {
                        setState(() {
                          _currentProperty = p;
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _reInitPropertyFuture() {
    final schedulerPendingItemListViewmodel =
        Provider.of<SchedulerPendingItemListViewmodel>(context, listen: false);
    plList.clear();
    if (widget.activity == null) {
      propertyList = schedulerPendingItemListViewmodel
          .schedulerPendingItemList.data!.data!;
    }
    if (_currentProperty == null) {
      _currentProperty = propertyList[0];
    }
    for (var i in propertyList) {
      plList.add(
        DropdownMenuItem<Property>(
          value: i,
          child: Text(
            i.propertyNameTranslation ??
                i.propertyName ??
                i.propertyNameTranslation.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
    }
  }

  Widget getAddActivitySchedulerCard() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  AppString.get(context).scheduler(),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            _AddActivityChip(
              _reInitActivityFuture,
              showActivityPickerDialog,
              activitiesWidgetsMap.keys.length != activitiesList.length,
              changeShedParamsList,
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              child: ElevatedButton(
                child: Text(
                  AppString.get(context).clearAll(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  primary: appSecondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    clearSchedulers();
                  });
                },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }

  void _reInitActivityFuture() {
    final activitySchedulerParamsListViewmodel =
        Provider.of<ActivitySchedulerParamsListViewmodel>(context,
            listen: false);

    final getActivitiesListViewmodel =
        Provider.of<GetActivitiesListViewmodel>(context, listen: false);

    // getActivitiesListViewmodel.fetchGetActivitiesListApi(token.toString());
    if (widget.activity == null) {
      activitiesList = getActivitiesListViewmodel.getActivitiesList.data!.data!;
      // .addAll();
    } else {
      final schedulerPendingActivityItemListViewmodel =
          Provider.of<SchedulerPendingActivityItemListViewmodel>(context,
              listen: false);
      print(
          '###################################################################################');
      print(widget.activity!.propertyId.toString());
      schedulerPendingActivityItemListViewmodel
          .fetchSchedulerPendingActivityItemListApi('activity',
              widget.activity!.propertyId.toString(), token.toString(),currentAppLanguage);

      activitiesList = schedulerPendingActivityItemListViewmodel
          .schedulerPendingActivityItemList.data!.data!;
    }

    Future.wait([
      activitySchedulerParamsListViewmodel
          .fetchActivitySchedulerParamsListApi(token.toString(),currentAppLanguage)
    ]).then((value) {
      activitiesList.clear();
      String error = '';
      bool status = true;
      // if (!value[0].status) {
      //   error = error + value[0].message;
      //   status = false;
      // }
      // if (!value[1].status) {
      //   error = error + '\n' + value[1].message;
      //   status = false;
      // }
      setState(() {
        showFab = true;

        activitiesList
            .addAll(getActivitiesListViewmodel.getActivitiesList.data!.data!);
        schedulerParamsList = activitySchedulerParamsListViewmodel
            .activitySchedulerParamsList.data!.data!;
        // if (status) {
        //   _statusActivity = Util.PageStatus.SUCCESS;
        // } else {
        //   // _statusActivity = Util.PageStatus.ERROR;
        //   // errorActivity = error;
        //   // showFab = false;
        // }
      });
    }).catchError((e) {
      setState(() {
        // _statusActivity = Util.PageStatus.ERROR;
        errorActivity = e;
        activitiesList.clear();
      });
    });
  }

  void clearSchedulers() {
    activitiesWidgetsMap.clear();
  }

  void changeShedParamsList(List<SchedulerParams> list) {
    schedulerParamsList = list;
  }

  void showActivityPickerDialog() {
    Navigator.of(context).pushNamed(RoutesName.activitySelectionPage,
        arguments: {
          'selection': activitiesWidgetsMap,
          'activities': activitiesList
        }).then((value) {
      if (value == null || !(value is List<Activities>)) {
        return;
      }
      // ignore: unnecessary_cast
      final list = value as List<Activities>;
      list.forEach((element) {
        activitiesWidgetsMap.putIfAbsent(
            element.activityId!.toInt(), () => element);
      });
      setState(() {});
    }).catchError((error) {
      print(error);
    });
  }

  void addNewSchedulers(BuildContext context) {
    final addNewActivitySchedulersViewModel =
        Provider.of<AddNewActivitySchedulersViewModel>(context, listen: false);

    List<Activities> actList = [];
    activitiesWidgetsMap.forEach((key, value) {
      value.propertyId = _currentProperty!.id!.toInt();
      actList.add(value);
    });

    print("actList $actList");
    print(actList.runtimeType);
    addNewActivitySchedulersViewModel.addNewActivitySchedulersApi(
        token.toString(), actList, context);
  }
}

class _SaveSchedulerFAB extends StatelessWidget {
  final Map<num, Activities> schedulerMap;
  final VoidCallback addNewSchedulers;
  final bool enabled;

  _SaveSchedulerFAB(this.schedulerMap, this.addNewSchedulers, this.enabled,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: appSecondaryColor,
      mini: true,
      child: Icon(Icons.done),
      onPressed: !enabled
          ? () {
              pressDoneV2(context);
            }
          : null,
    );
  }

  void pressDoneV2(BuildContext context) {
    if (schedulerMap.length <= 0) {
      Util.showSnackMessage(
          context, AppString.get(context).validateEmptySchedulerData());
      return;
    }
    bool status = true;
    for (var value in schedulerMap.values) {
      if (((value.scheduledDate == null ||
                  value.scheduleIntervalValue == null ||
                  value.scheduleIntervalUnit == null ||
                  value.frequencyUnit == null ||
                  value.frequencyQty == null) &&
              value.everyDaySpan == null) ||
          ((value.everyDaySpan == 'month' || value.everyDaySpan == 'week') &&
              (value.everyDaySpanValue == null ||
                  value.everyDaySpanValue!.isEmpty))) {
        status = false;
      }
    }

    if (status) {
      addNewSchedulers();
    } else {
      Util.showSnackMessage(
          context, AppString.get(context).validateSchedulerData());
      return;
    }
  }
}

class _AddActivityChip extends StatelessWidget {
  final VoidCallback refreshActivityFuture, showActivityPickerDialog;
  final bool showAddButton;
  final ValueChanged<List<SchedulerParams>> changeShedParamsList;

  _AddActivityChip(this.refreshActivityFuture, this.showActivityPickerDialog,
      this.showAddButton, this.changeShedParamsList,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: showAddButton ? showActivityPickerDialog : null,
        style: ElevatedButton.styleFrom(
          primary: appSecondaryColor,
        ),
        child: Text(
          '${AppString.get(context).add()} ${AppString.get(context).activity()}',
          style:
              Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _ActivityScheduler extends StatefulWidget {
  final Activities activity;
  final void Function(num) removeScheduler;
  final List<SchedulerParams> schedulerParamsList;
  final VoidCallback refreshWidget;

  _ActivityScheduler(this.activity, this.removeScheduler,
      this.schedulerParamsList, this.refreshWidget,
      {Key? key})
      : super(key: key);

  @override
  _ActivitySchedulerState createState() => _ActivitySchedulerState();
}

class _ActivitySchedulerState extends State<_ActivityScheduler> {
  bool _initiallyExpanded = false;
  late bool _showError;

  @override
  void initState() {
    super.initState();
    widget.activity.isAutoSchedulable = 1;
    widget.activity.active = 1;
  }

  @override
  Widget build(BuildContext context) {
    _showError = false;
    if (((widget.activity.scheduledDate == null ||
                widget.activity.scheduleIntervalValue == null ||
                widget.activity.scheduleIntervalUnit == null ||
                widget.activity.frequencyUnit == null ||
                widget.activity.frequencyQty == null) &&
            widget.activity.everyDaySpan == null) ||
        ((widget.activity.everyDaySpan == 'month' ||
                widget.activity.everyDaySpan == 'week') &&
            (widget.activity.everyDaySpanValue == null ||
                widget.activity.everyDaySpanValue!.isEmpty))) {
      _showError = true;
    } else {
      _showError = false;
    }
    return Card(
      margin: EdgeInsets.all(8),
      child: ExpandedItem(
        ExpansionEntry(
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_showError)
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      widget.activity.activityNameTranslation ??
                          widget.activity.activityName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: List.filled(
            1,
            ExpansionEntry(
              Padding(
                padding: EdgeInsets.all(0),
                child: _contentPage(context, widget.activity),
              ),
            ),
            growable: false,
          ),
        ),
        initiallyExpanded: _initiallyExpanded,
        onExpansionChanged: (value) => _initiallyExpanded = value,
      ),
    );
  }

  Widget _contentPage(BuildContext context, Activities activity) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    activity.active == 1
                        ? AppString.get(context).active()
                        : AppString.get(context).disabled(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Switch(
                    value: activity.active == 1,
                    onChanged: toggleActiveStatus,
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppString.get(context).autoSchedulable(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Switch(
                    value: activity.isAutoSchedulable == 1,
                    onChanged: toggleAutoScheduleStatus,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          //  Every day container
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    style: activity.everyDaySpan == 'day'
                        ? BorderStyle.solid
                        : BorderStyle.none),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: <Widget>[
                Radio(
                    value: 'day',
                    groupValue: activity.everyDaySpan,
                    onChanged: changeSchedulerType),
                Text(
                  '${AppString.get(context).every()} ${AppString.get(context).day()}',
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),

          // Every week container
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                style: activity.everyDaySpan == 'week'
                    ? BorderStyle.solid
                    : BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.only(
              bottom: activity.everyDaySpan == 'week' ? 8 : 0,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 'week',
                        groupValue: activity.everyDaySpan,
                        onChanged: changeSchedulerType,
                      ),
                      Text(
                        '${AppString.get(context).every()} ${AppString.get(context).week()}',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
                if (activity.everyDaySpan == 'week')
                  Container(
                    child: WeekDaysView(
                      enabledEntries: widget.activity.everyDaySpanValue,
                      isClickable: true,
                      onDayClicked: changeSchedulerDays,
                    ),
                  ),
              ],
            ),
          ),

          // Every month container
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    style: activity.everyDaySpan == 'month'
                        ? BorderStyle.solid
                        : BorderStyle.none),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.only(
                bottom: activity.everyDaySpan == 'month' ? 8 : 0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                          value: 'month',
                          groupValue: activity.everyDaySpan,
                          onChanged: changeSchedulerType),
                      Text(
                        '${AppString.get(context).every()} ${AppString.get(context).month()}',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
                if (activity.everyDaySpan == 'month')
                  LayoutBuilder(builder: (context, constraint) {
                    return MonthDaysView(
                      enabledEntries: activity.everyDaySpanValue,
                      containerWidth: constraint.maxWidth - 42,
                      isClickable: true,
                      onDayClicked: changeSchedulerDays,
                    );
                  })
              ],
            ),
          ),

          //  Arbitrary selection
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    style: activity.everyDaySpan == null
                        ? BorderStyle.solid
                        : BorderStyle.none),
                borderRadius: BorderRadius.circular(5)),
            padding:
                EdgeInsets.only(bottom: activity.everyDaySpan == null ? 8 : 0),
            margin:
                EdgeInsets.only(bottom: activity.everyDaySpan == null ? 8 : 0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                          value: null,
                          groupValue: activity.everyDaySpan,
                          onChanged: changeSchedulerType),
                      Text(
                        '${AppString.get(context).arbitrarily()}',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
                if (activity.everyDaySpan == null)
                  Container(
                    margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppString.get(context).schedule(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => _ScheduleChangePicker(
                                      widget.schedulerParamsList,
                                      activity,
                                      widget.refreshWidget));
                            },
                            child: Text(
                              (activity.scheduleIntervalValue == null ||
                                      activity.scheduleIntervalUnit == null)
                                  ? AppString.get(context).selectSchedule()
                                  : AppString.get(context).every() +
                                      ' ${activity.scheduleIntervalValue ?? activity.scheduleIntervalValue}' +
                                      ' ${activity.scheduleIntervalUnit ?? activity.scheduleIntervalUnit}' +
                                      ' - ${activity.frequencyQty} ' +
                                      AppString.get(context).times(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (activity.everyDaySpan == null)
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppString.get(context).scheduledOn(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: activity.scheduledDate != null
                                    ? DateTime.parse(
                                            activity.scheduledDate.toString())
                                        .toLocal()
                                    : DateTime.now().toLocal(),
                                firstDate: activity.scheduledDate != null
                                    ? DateTime.parse(
                                            activity.scheduledDate.toString())
                                        .subtract(Duration(days: 60))
                                    : DateTime.now()
                                        .subtract(Duration(days: 60)),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                              ).then((value) => changeScheduleOnDate(value!));
                            },
                            child: Text(
                              activity.scheduledDate != null
                                  ? DateFormat('d MMM yyyy').format(
                                      DateTime.parse(
                                              activity.scheduledDate.toString())
                                          .toLocal())
                                  : AppString.get(context).selectDate(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void toggleActiveStatus(bool enabled) {
    setState(() {
      widget.activity.active = enabled ? 1 : 0;
    });
  }

  void toggleAutoScheduleStatus(bool enabled) {
    setState(() {
      widget.activity.isAutoSchedulable = enabled ? 1 : 0;
    });
  }

  void changeScheduleOnDate(DateTime value) {
    if (value == null) {
      return;
    }
    setState(() {
      widget.activity.scheduledDate = value.toUtc().toIso8601String();
    });
  }

  void changeSchedulerDays(SelectableDay day) {
    print(day);
    setState(() {
      print(widget.activity.everyDaySpanValue);
      List<int>? list = widget.activity.everyDaySpanValue;
      if (list == null) {
        list = [];
        list.add(day.dayValue.toInt());
      } else {
        if (list.contains(day.dayValue)) {
          list.remove(day.dayValue);
        } else {
          list.add(day.dayValue.toInt());
        }
      }
      widget.activity.everyDaySpanValue = list;
      print(widget.activity.everyDaySpanValue);
    });
  }

  void changeSchedulerType(type) {
    setState(() {
      widget.activity.everyDaySpan = type;
      switch (type) {
        case 'week':
        case 'month':
          {
            break;
          }
        case 'day':
        default:
          {
            if (widget.activity.everyDaySpanValue != null) {
              widget.activity.everyDaySpanValue!.clear();
            }
            break;
          }
      }
    });
  }
}

class _ScheduleChangePicker extends StatefulWidget {
  final List<SchedulerParams> list;
  final Activities activity;
  final void Function() refreshParent;

  _ScheduleChangePicker(this.list, this.activity, this.refreshParent);

  @override
  State createState() => _ScheduleChangePickerState();
}

class _ScheduleChangePickerState extends State<_ScheduleChangePicker> {
  late SchedulerParams currentSched, currentFreq;
  late TextEditingController schController, freqController;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    schController = TextEditingController(
        text: widget.activity.scheduleIntervalValue != null
            ? widget.activity.scheduleIntervalValue.toString()
            : '');
    freqController = TextEditingController(
        text: widget.activity.frequencyQty != null
            ? widget.activity.frequencyQty.toString()
            : '');
  }

  @override
  void dispose() {
    schController.dispose();
    freqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      initialized = true;
      if (widget.list.isNotEmpty) {
        try {
          this.currentSched = widget.list[widget.list.indexWhere((element) =>
              element.paramCode == widget.activity.scheduleIntervalUnit)];
        } catch (e) {
          print(e);
          if (widget.list.length > 0) {
            this.currentSched = widget.list[0];
          }
        }
        try {
          this.currentFreq = widget.list[widget.list.indexWhere(
              (element) => element.paramCode == widget.activity.frequencyUnit)];
        } catch (e) {
          print(e);
          if (widget.list.length > 0) {
            this.currentFreq = widget.list[0];
          }
        }
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(top: 8, left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppString.get(context).schedule(),
              style:
                  Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: AppString.get(context).every(),
                          labelStyle: TextStyle(color: Colors.black)),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      controller: schController,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<SchedulerParams>(
                      underline: null,
                      value: currentSched,
                      items: widget.list
                          .map((e) => DropdownMenuItem<SchedulerParams>(
                                value: e,
                                child: Text(
                                  e.paramName!.toUpperCase(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ))
                          .toList(),
                      onChanged: (a) {
                        setState(() {
                          currentSched = a!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: freqController,
                decoration: InputDecoration(
                    labelText: AppString.get(context).times(),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppString.get(context).cancel(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      try {
                        widget.activity.scheduleIntervalValue =
                            int.parse(schController.text.trim().toString());
                        widget.activity.scheduleIntervalUnit =
                            currentSched.paramCode;
                        widget.activity.frequencyQty =
                            int.parse(freqController.text.trim().toString());
                        widget.activity.frequencyUnit = currentFreq.paramCode;
                      } catch (e) {
                        print(e);
                      }
                    });
                    Navigator.of(context).pop();
                    widget.refreshParent();
                  },
                  child: Text(
                    AppString.get(context).change(),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}





// ChangeNotifierProvider<
//                                     ActivitySchedulerParamsListViewmodel>.value(
//                                   value: activitySchedulerParamsListViewmodel,
//                                   child: Consumer<
//                                       ActivitySchedulerParamsListViewmodel>(
//                                     builder: (context, value, _) {
//                                       switch (value.activitySchedulerParamsList
//                                           .status!) {
//                                         case Status.LOADING:
//                                           return Center(
//                                               child:
//                                                   CircularProgressIndicator());

//                                         case Status.ERROR:
//                                           return ErrorScreenWidget(
//                                             onRefresh: () async {
//                                               fetchData();
//                                             },
//                                             loadingText: value
//                                                 .activitySchedulerParamsList
//                                                 .message
//                                                 .toString(),
//                                           );
//                                         case Status.COMPLETED:
//                                           // _reInitActivityFuture();

//                                           schedulerParamsList = value
//                                               .activitySchedulerParamsList
//                                               .data!
//                                               .data!;

//                                           return Container(
//                                             color: Colors.grey.shade200,
//                                             child: ListView.builder(
//                                               padding:
//                                                   EdgeInsets.only(bottom: 64),
//                                               itemCount: activitiesWidgetsMap
//                                                       .keys.length +
//                                                   2,
//                                               itemBuilder: (context, index) {
//                                                 Widget w;
//                                                 switch (index) {
//                                                   case 0:
//                                                     {
//                                                       {
//                                                         w = getPlotSelectorCard();
//                                                       }
//                                                       break;
//                                                     }
//                                                   case 1:
//                                                     {
//                                                       {
//                                                         w = getAddActivitySchedulerCard();
//                                                       }
//                                                       break;
//                                                     }
//                                                   default:
//                                                     {
//                                                       {
//                                                         Activities activity =
//                                                             activitiesWidgetsMap
//                                                                     .values
//                                                                     .toList()[
//                                                                 index - 2];
//                                                         w = _ActivityScheduler(
//                                                             activity,
//                                                             (value) =>
//                                                                 activitiesWidgetsMap
//                                                                     .remove(
//                                                                         value),
//                                                             schedulerParamsList,
//                                                             refreshWidget);
//                                                       }
//                                                       break;
//                                                     }
//                                                 }
//                                                 return w;
//                                               },
//                                             ),
//                                           );
//                                       }
//                                     },
//                                   ),
//                                 );
                          