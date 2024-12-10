import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Custom/custom_views.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/selectable_day.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitySchedulerItem_model.dart';
import 'package:siestaamsapp/Model/More_Model/activitySchedulerParamsList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitySchedulerItemDetails_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/activitySchedulerParamsList_view_model.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/updateActivitySchedulerItem_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class ActivitySchedulerDetailPage extends StatefulWidget {
  final dynamic activity;

  const ActivitySchedulerDetailPage({super.key, required this.activity});

  @override
  State<ActivitySchedulerDetailPage> createState() =>
      _ActivitySchedulerDetailPageState();
}

class _ActivitySchedulerDetailPageState
    extends State<ActivitySchedulerDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late Future _future;
  late ActivitySchedulerItem activity;
  late Map<String, dynamic> editedMap;
  late List<SchedulerParams> params;
  late Exception error;
  bool initialized = false, showUpdate = false;
  late AuthModal authModal;
  late bool canUpdate;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
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
    editedMap = new Map<String, dynamic>();
    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canUpdate = authModal.canUpdate!.contains(moduleActivityScheduler);
    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      token = widget.activity['token'].toString();
      print(
          '3333333333333333333333333333333333333333333333333333333333333333333333');
      print(widget.activity['schedulerId'].toString());
      print(widget.activity['activityName'].toString());
      print(widget.activity['token'].toString());
      final getActivitySchedulerItemViewmodel =
          Provider.of<GetActivitySchedulerItemViewmodel>(context,
              listen: false);

      getActivitySchedulerItemViewmodel.fetchGetActivitySchedulerItemApi(
          widget.activity['schedulerId'].toString(), token.toString(),currentAppLanguage);
      final activitySchedulerParamsListViewmodel =
          Provider.of<ActivitySchedulerParamsListViewmodel>(context,
              listen: false);

      activitySchedulerParamsListViewmodel
          .fetchActivitySchedulerParamsListApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final getActivitySchedulerItemViewmodel =
        Provider.of<GetActivitySchedulerItemViewmodel>(context);

    final activitySchedulerParamsListViewmodel =
        Provider.of<ActivitySchedulerParamsListViewmodel>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.activity['activityName'].toString(),
              style: TextStyle(fontSize: headerFontSize, color: Colors.white),
            ),
            Text(
              AppString.get(context).editActivitySchedule(),
              style:
                  TextStyle(fontSize: descriptionFontSize, color: Colors.white),
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                refresh();
              },
            ),
          )
        ],
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
                GetActivitySchedulerItemViewmodel>.value(
              value: getActivitySchedulerItemViewmodel,
              child: Consumer<GetActivitySchedulerItemViewmodel>(
                builder: (context, value, _) {
                  switch (value.getActivitySchedulerItem.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.getActivitySchedulerItem.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText:
                              value.getActivitySchedulerItem.message.toString(),
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
                      activity = value.getActivitySchedulerItem.data!.data!;
                      return ChangeNotifierProvider<
                          ActivitySchedulerParamsListViewmodel>.value(
                        value: activitySchedulerParamsListViewmodel,
                        child: Consumer<ActivitySchedulerParamsListViewmodel>(
                          builder: (context, value, _) {
                            switch (value.activitySchedulerParamsList.status!) {
                              case Status.LOADING:
                                return Center(
                                    child: CircularProgressIndicator());

                              case Status.ERROR:
                                if (value.activitySchedulerParamsList.message ==
                                    "No Internet Connection") {
                                  return ErrorScreenWidget(
                                    onRefresh: () async {
                                      fetchData();
                                    },
                                    loadingText: value
                                        .activitySchedulerParamsList.message
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
                                resetData(
                                    getActivitySchedulerItemViewmodel
                                        .getActivitySchedulerItem.data!.data!,
                                    value.activitySchedulerParamsList.data!
                                        .data!);
                                return LayoutBuilder(
                                  builder: (context, constraint) {
                                    return Container(
                                      height: constraint.maxHeight,
                                      width: constraint.maxWidth,
                                      color: Colors.grey.shade200,
                                      child: SingleChildScrollView(
                                          child: _contentPage(
                                              activity, constraint)),
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
        },
      ),
    );
  }

  void refresh() {
    setState(() {
      editedMap.clear();
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    showUpdate = editedMap.isNotEmpty;
  }

  void updateWidget() {
    setState(() {});
  }

  void toggleActiveStatus(bool enabled) {
    setState(() {
      editedMap.update('active', (value) => enabled ? 1 : 0,
          ifAbsent: () => enabled ? 1 : 0);
    });
  }

  void toggleAutoScheduleStatus(bool? enabled) {
    setState(() {
      editedMap.update('isAutoSchedulable', (value) => enabled! ? 1 : 0,
          ifAbsent: () => enabled! ? 1 : 0);
    });
  }

  void changeScheduleOnDate(DateTime dateTime) {
    setState(() {
      editedMap.update('scheduledDate', (value) => dateTime.toIso8601String(),
          ifAbsent: () => dateTime.toIso8601String());
    });
  }

  void changeSchedulerWeekDays(SelectableDay day) {
    setState(() {
      editedMap.update('everyDaySpanValue', (value) {
        List<dynamic> list = value as List<dynamic>;
        if (day.isSelected) {
          list.remove(day.dayValue);
        } else {
          list.add(day.dayValue);
        }
        return list;
      }, ifAbsent: () {
        List<dynamic>? list = activity.everyDaySpanValue;
        if (list == null) {
          list = [];
        }
        if (day.isSelected) {
          list.remove(day.dayValue);
        } else {
          list.add(day.dayValue.toInt());
        }
        return list;
      });
    });
  }

  void changeSchedulerMonthDays(SelectableDay day) {
    setState(() {
      editedMap.update('everyDaySpanValue', (value) {
        dynamic list = value as dynamic;
        if (day.isSelected) {
          list.remove(day.dayValue);
        } else {
          list.add(day.dayValue);
        }
        return list;
      }, ifAbsent: () {
        dynamic list = activity.everyDaySpanValue;
        if (list == null) {
          list = [];
        }
        if (day.isSelected) {
          list.remove(day.dayValue);
        } else {
          list.add(day.dayValue.toInt());
        }
        return list;
      });
    });
  }

  void changeSchedulerType(type) {
    setState(() {
      editedMap.update('everyDaySpan', (value) => type, ifAbsent: () => type);
      switch (type) {
        case 'week':
          {
            editedMap.remove('everyDaySpanValue');
            break;
          }
        case 'month':
          {
            editedMap.remove('everyDaySpanValue');
            break;
          }
        case 'day':
          {
            editedMap.remove('everyDaySpanValue');
            break;
          }
        default:
          {
            editedMap.update('everyDaySpanValue', (value) {
              List<dynamic> data = value as List<dynamic>;
              data.clear();
              return data;
            }, ifAbsent: () {
              List<num> data = [];
              return data;
            });
            editedMap.update('everyDaySpanValue', (value) {
              List<num> data = value as List<num>;
              data.clear();
              return data;
            }, ifAbsent: () {
              List<num> data = [];
              return data;
            });
            break;
          }
      }
    });
  }

  void resetScheduleOnDate() {
    setState(() {
      editedMap.remove('scheduledDate');
    });
  }

  void resetData(
      ActivitySchedulerItem newActivity, List<SchedulerParams> params) {
    this.activity = newActivity;
    this.params = params;
  }

  Widget _contentPage(ActivitySchedulerItem activity,
      [BoxConstraints? constraint]) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppString.get(context).detail(),
                    style: TextStyle(
                      fontSize: headerFontSize,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  Table(
                    columnWidths: {
                      0: FractionColumnWidth(0.2),
                      1: FractionColumnWidth(0.05)
                    },
                    children: [
                      TableRow(
                        children: <Widget>[
                          Text(
                            AppString.get(context).activity(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            ': ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            activity.activityNameTranslation ??
                                      activity.activityName.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Text(
                            AppString.get(context).plotNo(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            ': ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            activity.propertyNumber.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppString.get(context).schedule(),
                    style: TextStyle(
                      fontSize: headerFontSize,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  Container(
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            (editedMap.containsKey('active')
                                        ? (editedMap['active'] as num)
                                        : activity.active) ==
                                    1
                                ? AppString.get(context).active()
                                : AppString.get(context).disabled(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Switch(
                            value: (editedMap.containsKey('active')
                                    ? (editedMap['active'] as num)
                                    : activity.active) ==
                                1,
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
                          Checkbox(
                            value: (editedMap.containsKey('isAutoSchedulable')
                                    ? (editedMap['isAutoSchedulable'] as num)
                                    : activity.isAutoSchedulable) ==
                                1,
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
                            style: (editedMap.containsKey('everyDaySpan')
                                        ? editedMap['everyDaySpan']
                                        : activity.everyDaySpan) ==
                                    'day'
                                ? BorderStyle.solid
                                : BorderStyle.none),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: 'day',
                            groupValue: editedMap.containsKey('everyDaySpan')
                                ? editedMap['everyDaySpan']
                                : activity.everyDaySpan,
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
                            style: (editedMap.containsKey('everyDaySpan')
                                        ? editedMap['everyDaySpan']
                                        : activity.everyDaySpan) ==
                                    'week'
                                ? BorderStyle.solid
                                : BorderStyle.none),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        bottom: (editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'week'
                            ? 8
                            : 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: 'week',
                                  groupValue:
                                      editedMap.containsKey('everyDaySpan')
                                          ? editedMap['everyDaySpan']
                                          : activity.everyDaySpan,
                                  onChanged: changeSchedulerType),
                              Text(
                                '${AppString.get(context).every()} ${AppString.get(context).week()}',
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        ),
                        if ((editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'week' &&
                            editedMap.containsKey('everyDaySpanValue'))
                          Container(
                            child: WeekDaysView(
                              enabledEntries: editedMap['everyDaySpanValue'],
                              isClickable: true,
                              onDayClicked: changeSchedulerWeekDays,
                            ),
                          ),
                        if ((editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'week' &&
                            !editedMap.containsKey('everyDaySpanValue'))
                          Container(
                            child: WeekDaysView(
                              enabledEntries: activity.everyDaySpanValue,
                              isClickable: true,
                              onDayClicked: changeSchedulerWeekDays,
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
                            style: (editedMap.containsKey('everyDaySpan')
                                        ? editedMap['everyDaySpan']
                                        : activity.everyDaySpan) ==
                                    'month'
                                ? BorderStyle.solid
                                : BorderStyle.none),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        bottom: (editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'month'
                            ? 8
                            : 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: 'month',
                                  groupValue:
                                      editedMap.containsKey('everyDaySpan')
                                          ? editedMap['everyDaySpan']
                                          : activity.everyDaySpan,
                                  onChanged: changeSchedulerType),
                              Text(
                                '${AppString.get(context).every()} ${AppString.get(context).month()}',
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        ),
                        if ((editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'month' &&
                            editedMap.containsKey('everyDaySpanValue'))
                          MonthDaysView(
                            enabledEntries: editedMap['everyDaySpanValue'],
                            containerWidth: constraint!.maxWidth - 42,
                            isClickable: true,
                            onDayClicked: changeSchedulerMonthDays,
                          ),
                        if ((editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                'month' &&
                            !editedMap.containsKey('everyDaySpanValue'))
                          MonthDaysView(
                            enabledEntries: activity.everyDaySpanValue,
                            containerWidth: constraint!.maxWidth - 42,
                            isClickable: true,
                            onDayClicked: changeSchedulerMonthDays,
                          ),
                      ],
                    ),
                  ),
                  //  Arbitrarily choice
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            style: (editedMap.containsKey('everyDaySpan')
                                        ? editedMap['everyDaySpan']
                                        : activity.everyDaySpan) ==
                                    null
                                ? BorderStyle.solid
                                : BorderStyle.none),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.only(
                        bottom: (editedMap.containsKey('everyDaySpan')
                                    ? editedMap['everyDaySpan']
                                    : activity.everyDaySpan) ==
                                null
                            ? 8
                            : 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: null,
                                  groupValue:
                                      editedMap.containsKey('everyDaySpan')
                                          ? editedMap['everyDaySpan']
                                          : activity.everyDaySpan,
                                  onChanged: changeSchedulerType),
                              Text(
                                '${AppString.get(context).arbitrarily()}',
                                style: Theme.of(context).textTheme.subtitle1,
                              )
                            ],
                          ),
                        ),
                        if ((editedMap.containsKey('everyDaySpan')
                                ? editedMap['everyDaySpan']
                                : activity.everyDaySpan) ==
                            null)
                          Container(
                            margin:
                                EdgeInsets.only(bottom: 5, left: 5, right: 5),
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
                                        builder: (context) =>
                                            _ScheduleChangePicker(
                                          params,
                                          activity,
                                          updateWidget,
                                          editedMap,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      (editedMap
                                                  .containsKey(
                                                      'scheduleIntervalValue') &&
                                              editedMap.containsKey(
                                                  'scheduleIntervalUnit') &&
                                              editedMap
                                                  .containsKey('frequencyQty'))
                                          ? '${AppString.get(context).every()} ${editedMap['scheduleIntervalValue'] as num} ${editedMap['scheduleIntervalUnit'] as String}  - ${editedMap['frequencyQty'] as num} ${AppString.get(context).times()}'
                                          : (activity.scheduleIntervalValue !=
                                                      null &&
                                                  activity.scheduleIntervalUnit !=
                                                      null &&
                                                  activity.frequencyQty != null)
                                              ? '${AppString.get(context).every()} ${activity.scheduleIntervalValue} ${activity.scheduleIntervalUnit}  - ${activity.frequencyQty} ${AppString.get(context).times()}'
                                              : AppString.get(context)
                                                  .selectSchedule(),
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
                        if ((editedMap.containsKey('everyDaySpan')
                                ? editedMap['everyDaySpan']
                                : activity.everyDaySpan) ==
                            null)
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
                                        initialDate: editedMap
                                                .containsKey('scheduledDate')
                                            ? DateTime.parse(
                                                    editedMap['scheduledDate'])
                                                .toLocal()
                                            : activity.scheduledDate != null
                                                ? DateTime.parse(activity
                                                        .scheduledDate
                                                        .toString())
                                                    .toLocal()
                                                : DateTime.now().toLocal(),
                                        firstDate: (editedMap.containsKey(
                                                    'scheduledDate')
                                                ? DateTime.parse(editedMap[
                                                        'scheduledDate'])
                                                    .toLocal()
                                                : activity.scheduledDate != null
                                                    ? DateTime.parse(activity
                                                            .scheduledDate
                                                            .toString())
                                                        .toLocal()
                                                    : DateTime.now().toLocal())
                                            .subtract(Duration(days: 60)),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 365)),
                                      ).then((value) {
                                        if (value == null) {
                                          return;
                                        }
                                        changeScheduleOnDate(value);
                                      }).catchError((error) {
                                        print(error);
                                      });
                                    },
                                    onLongPress: () => resetScheduleOnDate(),
                                    child: Text(
                                      editedMap.containsKey('scheduledDate')
                                          ? DateFormat('d MMM yyyy').format(
                                              DateTime.parse(editedMap[
                                                      'scheduledDate'])
                                                  .toLocal())
                                          : activity.scheduledDate != null
                                              ? DateFormat('d MMM yyyy').format(
                                                  DateTime.parse(activity
                                                          .scheduledDate
                                                          .toString())
                                                      .toLocal())
                                              : AppString.get(context)
                                                  .selectDate(),
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
                        if ((editedMap.containsKey('everyDaySpan')
                                ? editedMap['everyDaySpan']
                                : activity.everyDaySpan) ==
                            null)
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppString.get(context).lastInterval(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  activity.lastRunDate == null
                                      ? '-'
                                      : DateFormat('d MMM yyyy').format(
                                          DateTime.parse(activity.lastRunDate
                                                  .toString())
                                              .toLocal()),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                buttonColor: showUpdate && canUpdate
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).disabledColor,
              ),
              child: ElevatedButton(
                child: Text(
                  AppString.get(context).update(),
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: appSecondaryColor,
                ),
                onPressed: showUpdate && canUpdate
                    ? () {
                        _updateScheduler(
                            context, activity, editedMap, token.toString());
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleChangePicker extends StatefulWidget {
  final List<SchedulerParams> list;
  final ActivitySchedulerItem activity;
  final void Function() refreshParent;
  final Map<String, dynamic> editedMap;

  _ScheduleChangePicker(
    this.list,
    this.activity,
    this.refreshParent,
    this.editedMap,
  );

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
    String schedText, freqText;

    schedText = widget.editedMap.containsKey('scheduleIntervalValue')
        ? '${widget.editedMap['scheduleIntervalValue'] as num}'
        : widget.activity.scheduleIntervalValue?.toString() ?? '';

    freqText = widget.editedMap.containsKey('frequencyQty')
        ? '${widget.editedMap['frequencyQty'] as num}'
        : widget.activity.frequencyQty?.toString() ?? '';

    schController = TextEditingController(text: schedText);
    freqController = TextEditingController(text: freqText);

    if (widget.list.isNotEmpty) {
      if (widget.editedMap.containsKey('scheduleIntervalUnit')) {
        try {
          this.currentSched = widget.list[widget.list.indexWhere((element) =>
              element.paramCode ==
              widget.editedMap['scheduleIntervalUnit'] as String)];
        } catch (e) {
          this.currentSched = widget.list[0];
        }
      } else {
        try {
          this.currentSched = widget.list[widget.list.indexWhere((element) =>
              element.paramCode == widget.activity.scheduleIntervalUnit)];
        } catch (e) {
          this.currentSched = widget.list[0];
        }
      }
      if (widget.editedMap.containsKey('frequencyUnit')) {
        try {
          this.currentFreq = widget.list[widget.list.indexWhere((element) =>
              element.paramCode ==
              widget.editedMap['frequencyUnit'] as String)];
        } catch (e) {
          this.currentFreq = widget.list[0];
        }
      } else {
        try {
          this.currentFreq = widget.list[widget.list.indexWhere(
              (element) => element.paramCode == widget.activity.frequencyUnit)];
        } catch (e) {
          this.currentFreq = widget.list[0];
        }
      }
    }
  }

  void updateData(
      String schedUnit, num schedQty, String freqUnit, num freqQty) {
    widget.editedMap.update('scheduleIntervalUnit', (value) => schedUnit,
        ifAbsent: () => schedUnit);
    widget.editedMap.update('scheduleIntervalValue', (value) => schedQty,
        ifAbsent: () => schedQty);
    widget.editedMap
        .update('frequencyUnit', (value) => freqUnit, ifAbsent: () => freqUnit);
    widget.editedMap
        .update('frequencyQty', (value) => freqQty, ifAbsent: () => freqQty);
  }

  @override
  void dispose() {
    schController.dispose();
    freqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      updateData(
                          currentSched.paramCode.toString(),
                          int.parse(schController.text.trim().toString()),
                          currentFreq.paramCode.toString(),
                          int.parse(freqController.text.trim().toString()));
                    });
                    Navigator.of(context).pop();
                    widget.refreshParent();
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
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

void _updateScheduler(BuildContext context, ActivitySchedulerItem activity,
    Map<String, dynamic> editedMap, String token) async {
  final updateActivitySchedulerItemViewModel =
      Provider.of<UpdateActivitySchedulerItemViewModel>(context, listen: false);

  num active;
  if (editedMap.containsKey('active')) {
    active = editedMap['active'] as num;
  } else {
    active = activity.active!;
  }
  num isAutoSchedulable;
  if (editedMap.containsKey('isAutoSchedulable')) {
    isAutoSchedulable = editedMap['isAutoSchedulable'] as num;
  } else {
    isAutoSchedulable = activity.isAutoSchedulable!;
  }

  DateTime? scheduledDate;
  num? scheduleIntervalValue, frequencyQty;
  String? scheduleIntervalUnit, frequencyUnit, everyDaySpan;
  dynamic everyDaySpanValue;

  if (editedMap.containsKey('everyDaySpan')) {
    everyDaySpan = editedMap['everyDaySpan'];
    switch (everyDaySpan) {
      case 'day':
        {
          scheduledDate = null;
          scheduleIntervalValue = null;
          scheduleIntervalUnit = null;
          frequencyQty = null;
          frequencyUnit = null;
          everyDaySpanValue = null;
          break;
        }
      case 'week':
      case 'month':
        {
          scheduledDate = null;
          scheduleIntervalValue = null;
          scheduleIntervalUnit = null;
          frequencyQty = null;
          frequencyUnit = null;
          everyDaySpanValue = editedMap['everyDaySpanValue'];
          break;
        }
      default:
        {
          scheduledDate = editedMap['scheduledDate'] != null
              ? DateTime.parse(editedMap['scheduledDate'])
              : null;
          scheduleIntervalValue = editedMap['scheduleIntervalValue'] as num;
          scheduleIntervalUnit = editedMap['scheduleIntervalUnit'] as String;
          frequencyQty = editedMap['frequencyQty'] as num;
          frequencyUnit = editedMap['frequencyUnit'] as String;
          everyDaySpan = null;
          everyDaySpanValue = null;
          break;
        }
    }
  } else {
    everyDaySpan = activity.everyDaySpan;
    switch (everyDaySpan) {
      case 'day':
        {
          scheduledDate = null;
          scheduleIntervalValue = null;
          scheduleIntervalUnit = null;
          frequencyQty = null;
          frequencyUnit = null;
          everyDaySpanValue = null;
          break;
        }
      case 'week':
      case 'month':
        {
          scheduledDate = null;
          scheduleIntervalValue = null;
          scheduleIntervalUnit = null;
          frequencyQty = null;
          frequencyUnit = null;
          if (editedMap.containsKey('everyDaySpanValue')) {
            everyDaySpanValue = editedMap['everyDaySpanValue'];
          } else {
            everyDaySpanValue = activity.everyDaySpanValue;
          }
          break;
        }
      default:
        {
          if (editedMap.containsKey('scheduledDate')) {
            scheduledDate =
                DateTime.parse(editedMap['scheduledDate'] as String);
          } else {
            scheduledDate = DateTime.parse(activity.scheduledDate.toString());
          }

          if (editedMap.containsKey('scheduleIntervalValue')) {
            scheduleIntervalValue = editedMap['scheduleIntervalValue'] as num;
          } else {
            scheduleIntervalValue = activity.scheduleIntervalValue;
          }

          if (editedMap.containsKey('scheduleIntervalUnit')) {
            scheduleIntervalUnit = editedMap['scheduleIntervalUnit'] as String;
          } else {
            scheduleIntervalUnit = activity.scheduleIntervalUnit;
          }

          if (editedMap.containsKey('frequencyQty')) {
            frequencyQty = editedMap['frequencyQty'] as num;
          } else {
            frequencyQty = activity.frequencyQty;
          }

          if (editedMap.containsKey('frequencyUnit')) {
            frequencyUnit = editedMap['frequencyUnit'] as String;
          } else {
            frequencyUnit = activity.frequencyUnit;
          }
          everyDaySpan = null;
          everyDaySpanValue = null;
          break;
        }
    }
  }

  try {
    String? date;
    if (scheduledDate == null) {
      date = null;
    } else {
      date =
          '${scheduledDate.toLocal().year}-${scheduledDate.toLocal().month.toString().padLeft(2, '0')}-${scheduledDate.toLocal().day.toString().padLeft(2, '0')}';
    }
    print(
        'alalallalallllllllllllllllllllllaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(date);
    print(scheduleIntervalValue);
    print(scheduleIntervalUnit);
    print(frequencyQty);
    print(frequencyUnit);
    print(active > 0 ? true : false);
    print(isAutoSchedulable > 0 ? true : false);
    print(everyDaySpan.toString());
    print(everyDaySpanValue);
    print(activity.schedulerId.toString());
    print(token.toString());
    print(
        'alalallalallllllllllllllllllllllaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    Map data = {
      "scheduledDate": date,
      "scheduleIntervalValue": scheduleIntervalValue,
      "scheduleIntervalUnit": scheduleIntervalUnit,
      "frequencyQty": frequencyQty,
      "frequencyUnit": frequencyUnit,
      "active": active > 0 ? true : false,
      "autoSchedulable": isAutoSchedulable > 0 ? true : false,
      "everyDaySpan": everyDaySpan,
      "everyDaySpanValue": everyDaySpanValue,
    };

    updateActivitySchedulerItemViewModel.updateActivitySchedulerItemApi(
        activity.schedulerId.toString(), token.toString(), data, context);
  } catch (e) {
    Navigator.of(context).pop();
    // showDialog(
    //     context: context,
    //     builder: (b) => Util.getAlertDialog(
    //         context, AppString.get(context).message(), e.toString()));
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:siestaamsapp/Custom/custom_views.dart';
// import 'package:siestaamsapp/Data/Response/status.dart';
// import 'package:siestaamsapp/Model/Custom_Model/selectable_day.dart';
// import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitySchedulerItem_model.dart';
// import 'package:siestaamsapp/Model/More_Model/activitySchedulerParamsList_model.dart';
// import 'package:siestaamsapp/Res/colors.dart';
// import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
// import 'package:siestaamsapp/Utils/utils.dart';
// import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
// import 'package:siestaamsapp/View/main_admin_providers.dart';
// import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivitySchedulerItemDetails_view_model.dart';
// import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/activitySchedulerParamsList_view_model.dart';
// import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Scheduler_View_Model/updateActivitySchedulerItem_view_model.dart';
// import 'package:siestaamsapp/constants/modules.dart';
// import 'package:siestaamsapp/constants/string_res.dart';
// import 'package:siestaamsapp/Utils/utils.dart' as Util;

// class ActivitySchedulerDetailPage extends StatefulWidget {
//   final dynamic activity;

//   const ActivitySchedulerDetailPage({super.key, required this.activity});

//   @override
//   State<ActivitySchedulerDetailPage> createState() =>
//       _ActivitySchedulerDetailPageState();
// }

// class _ActivitySchedulerDetailPageState
//     extends State<ActivitySchedulerDetailPage> {
//   //   final _formKey = GlobalKey<FormState>();
// //   late Future _future;
// //   late ActivitySchedulerItem activity;
// //   late Map<String, dynamic> editedMap;
// //   late List<SchedulerParams> params;
// //   late Exception error;
// //   bool initialized = false, showUpdate = false;
// //   late AuthModal authModal;
// //   late bool canUpdate;
// //   UserPreferences userPreference = UserPreferences();
// //   dynamic UserData;
// //   String? token;
// //   late Future<void> fetchDataFuture;

//   final _formKey = GlobalKey<FormState>();
//   Future _future;
//   ActivitySchedulerItem activity;
//   Map<String, dynamic> editedMap;
//   List<SchedulerParams> params;
//   Exception error;
//   bool initialized = false, showUpdate = false;
//   // ProgressDialog progressDialog;
//   AuthModal authModal;
//   bool canUpdate;

//   @override
//   void initState() {
//     super.initState();
//     editedMap = new Map<String, dynamic>();
//     authModal =
//         Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
//     canUpdate = authModal.canUpdate!.contains(moduleActivityScheduler);
//     _reInitLoadDataFuture();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               widget.activity.activityName,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline6
//                   ?.copyWith(color: Colors.white),
//             ),
//             Text(AppString.get(context).editActivitySchedule(),
//                 style: Theme.of(context)
//                     .textTheme
//                     .subtitle1
//                     ?.copyWith(color: Colors.white)),
//           ],
//         ),
//         actions: <Widget>[
//           Container(
//             child: IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: () {
//                 refresh();
//               },
//             ),
//           )
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraint) {
//           return Container(
//             height: constraint.maxHeight,
//             width: constraint.maxWidth,
//             color: Color.fromRGBO(238, 238, 238, 1),
//             child: SingleChildScrollView(
//               child: FutureBuilder<List<ResponseEnvelope>>(
//                 future: _future,
//                 builder: (context, snapshot) {
//                   Widget w;

//                   switch (snapshot.connectionState) {
//                     case ConnectionState.active:
//                       w = Util.getErrorView(context, callback: refresh);
//                       break;
//                     case ConnectionState.none:
//                       w = Util.getErrorView(context, callback: refresh);
//                       break;
//                     case ConnectionState.waiting:
//                       w = Util.getProgressView(context);
//                       break;
//                     case ConnectionState.done:
//                       if (snapshot.hasError) {
//                         w = Util.getErrorView(
//                           context,
//                           error: snapshot.error,
//                           callback: refresh,
//                         );
//                       } else if (!snapshot.hasData) {
//                         w = Util.getErrorView(
//                           context,
//                           error: AppString.get(context).somethingWentWrong(),
//                           callback: refresh,
//                         );
//                       } else {
//                         if (!snapshot.data[0].status) {
//                           w = Util.getEmptyDataView(context,
//                               error: snapshot.data[0].message, callback: () {
//                             refresh();
//                           });
//                         } else {
//                           resetData(
//                               Activity.fromJson(snapshot.data[0].data),
//                               Util.getList<SchedulerParams>(
//                                   snapshot.data[1].data));
//                           w = _contentPage(activity, constraint);
//                         }
//                       }
//                       break;
//                   }
//                   return w;
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void refresh() {
//     setState(() {
//       editedMap.clear();
//       _reInitLoadDataFuture();
//     });
//   }

//   void _reInitLoadDataFuture() {
//     _future = Future.wait([
//       networkApi.getActivitySchedulerItem(
//         context: context,
//         id: widget.activity.schedulerId.toInt(),
//       ),
//       networkApi.getActivitySchedulerParams(context: context)
//     ]);
//   }

//   @override
//   void setState(VoidCallback fn) {
//     super.setState(fn);
//     showUpdate = editedMap.isNotEmpty;
//   }

//   void updateWidget() {
//     setState(() {});
//   }

//   void toggleActiveStatus(bool enabled) {
//     setState(() {
//       editedMap.update('active', (value) => enabled ? 1 : 0,
//           ifAbsent: () => enabled ? 1 : 0);
//     });
//   }

//   void toggleAutoScheduleStatus(bool enabled) {
//     setState(() {
//       editedMap.update('isAutoSchedulable', (value) => enabled ? 1 : 0,
//           ifAbsent: () => enabled ? 1 : 0);
//     });
//   }

//   void changeScheduleOnDate(DateTime dateTime) {
//     setState(() {
//       editedMap.update('scheduledDate', (value) => dateTime.toIso8601String(),
//           ifAbsent: () => dateTime.toIso8601String());
//     });
//   }

//   void changeSchedulerWeekDays(SelectableDay day) {
//     setState(() {
//       editedMap.update('everyDaySpanValue', (value) {
//         List<num> list = value as List<num>;
//         if (day.isSelected) {
//           list.remove(day.dayValue);
//         } else {
//           list.add(day.dayValue);
//         }
//         return list;
//       }, ifAbsent: () {
//         List<int>? list = activity.everyDaySpanValue;
//         if (list == null) {
//           list = [];
//         }
//         if (day.isSelected) {
//           list.remove(day.dayValue);
//         } else {
//           list.add(day.dayValue.toInt());
//         }
//         return list;
//       });
//     });
//   }

//   void changeSchedulerMonthDays(SelectableDay day) {
//     setState(() {
//       editedMap.update('everyDaySpanValue', (value) {
//         List<num> list = value as List<num>;
//         if (day.isSelected) {
//           list.remove(day.dayValue);
//         } else {
//           list.add(day.dayValue);
//         }
//         return list;
//       }, ifAbsent: () {
//         List<num>? list = activity.everyDaySpanValue;
//         if (list == null) {
//           list = [];
//         }
//         if (day.isSelected) {
//           list.remove(day.dayValue);
//         } else {
//           list.add(day.dayValue);
//         }
//         return list;
//       });
//     });
//   }

//   void changeSchedulerType(String type) {
//     setState(() {
//       editedMap.update('everyDaySpan', (value) => type, ifAbsent: () => type);
//       switch (type) {
//         case 'week':
//           {
//             editedMap.remove('everyDaySpanValue');
//             break;
//           }
//         case 'month':
//           {
//             editedMap.remove('everyDaySpanValue');
//             break;
//           }
//         case 'day':
//         default:
//           {
//             editedMap.update('everyDaySpanValue', (value) {
//               List<num> data = value as List<num>;
//               data.clear();
//               return data;
//             }, ifAbsent: () {
//               List<num> data = [];
//               return data;
//             });
//             editedMap.update('everyDaySpanValue', (value) {
//               List<num> data = value as List<num>;
//               data.clear();
//               return data;
//             }, ifAbsent: () {
//               List<num> data = [];
//               return data;
//             });
//             break;
//           }
//       }
//     });
//   }

//   void resetScheduleOnDate() {
//     setState(() {
//       editedMap.remove('scheduledDate');
//     });
//   }

//   void resetData(
//       ActivitySchedulerItem newActivity, List<SchedulerParams> params) {
//     this.activity = newActivity;
//     this.params = params;
//   }

//   Widget _contentPage(ActivitySchedulerItem activity,
//       [BoxConstraints? constraint]) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Card(
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Text(
//                     AppString.get(context).detail(),
//                     style: 
      // style: TextStyle(
      //   fontSize: headerFontSize,
      // ),
//                   ),
//                   Divider(
//                     color: Colors.grey,
//                     height: 10,
//                   ),
//                   Table(
//                     columnWidths: {
//                       0: FractionColumnWidth(0.2),
//                       1: FractionColumnWidth(0.05)
//                     },
//                     children: [
//                       TableRow(
//                         children: <Widget>[
//                           Text(
//                             AppString.get(context).activity(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Text(
//                             ': ',
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Text(
//                             activity.activityName.toString(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                         ],
//                       ),
//                       TableRow(
//                         children: <Widget>[
//                           Text(
//                             AppString.get(context).plotNo(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Text(
//                             ': ',
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Text(
//                             activity.propertyNumber.toString(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Card(
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Text(
//                     AppString.get(context).schedule(),
//                     style: 
      // style: TextStyle(
      //   fontSize: headerFontSize,
      // ),
//                   ),
//                   Divider(
//                     color: Colors.grey,
//                     height: 10,
//                   ),
//                   Container(
//                     child: GestureDetector(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             (editedMap.containsKey('active')
//                                         ? (editedMap['active'] as num)
//                                         : activity.active) ==
//                                     1
//                                 ? AppString.get(context).active()
//                                 : AppString.get(context).disabled(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Switch(
//                             value: (editedMap.containsKey('active')
//                                     ? (editedMap['active'] as num)
//                                     : activity.active) ==
//                                 1,
//                             onChanged: toggleActiveStatus,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: GestureDetector(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             AppString.get(context).autoSchedulable(),
//                             style: Theme.of(context).textTheme.subtitle1,
//                           ),
//                           Checkbox(
//                             value: (editedMap.containsKey('isAutoSchedulable')
//                                     ? (editedMap['isAutoSchedulable'] as num)
//                                     : activity.isAutoSchedulable) ==
//                                 1,
//                             onChanged: toggleAutoScheduleStatus,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.grey,
//                   ),

//                   //  Every day container
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             style: (editedMap.containsKey('everyDaySpan')
//                                         ? editedMap['everyDaySpan']
//                                         : activity.everyDaySpan) ==
//                                     'day'
//                                 ? BorderStyle.solid
//                                 : BorderStyle.none),
//                         borderRadius: BorderRadius.circular(5)),
//                     child: Row(
//                       children: <Widget>[
//                         Radio(
//                             value: 'day',
//                             groupValue: editedMap.containsKey('everyDaySpan')
//                                 ? editedMap['everyDaySpan']
//                                 : activity.everyDaySpan,
//                             onChanged: changeSchedulerType),
//                         Text(
//                           '${AppString.get(context).every()} ${AppString.get(context).day()}',
//                           style: Theme.of(context).textTheme.subtitle1,
//                         )
//                       ],
//                     ),
//                   ),

//                   // Every week container
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             style: (editedMap.containsKey('everyDaySpan')
//                                         ? editedMap['everyDaySpan']
//                                         : activity.everyDaySpan) ==
//                                     'week'
//                                 ? BorderStyle.solid
//                                 : BorderStyle.none),
//                         borderRadius: BorderRadius.circular(5)),
//                     padding: EdgeInsets.only(
//                         bottom: (editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'week'
//                             ? 8
//                             : 0),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           child: Row(
//                             children: <Widget>[
//                               Radio(
//                                   value: 'week',
//                                   groupValue:
//                                       editedMap.containsKey('everyDaySpan')
//                                           ? editedMap['everyDaySpan']
//                                           : activity.everyDaySpan,
//                                   onChanged: changeSchedulerType),
//                               Text(
//                                 '${AppString.get(context).every()} ${AppString.get(context).week()}',
//                                 style: Theme.of(context).textTheme.subtitle1,
//                               )
//                             ],
//                           ),
//                         ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'week' &&
//                             editedMap.containsKey('everyDaySpanValue'))
//                           Container(
//                             child: WeekDaysView(
//                               enabledEntries:
//                                   editedMap['everyDaySpanValue'],
//                               isClickable: true,
//                               onDayClicked: changeSchedulerWeekDays,
//                             ),
//                           ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'week' &&
//                             !editedMap.containsKey('everyDaySpanValue'))
//                           Container(
//                             child: WeekDaysView(
//                               enabledEntries: activity.everyDaySpanValue,
//                               isClickable: true,
//                               onDayClicked: changeSchedulerWeekDays,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),

//                   // Every month container
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             style: (editedMap.containsKey('everyDaySpan')
//                                         ? editedMap['everyDaySpan']
//                                         : activity.everyDaySpan) ==
//                                     'month'
//                                 ? BorderStyle.solid
//                                 : BorderStyle.none),
//                         borderRadius: BorderRadius.circular(5)),
//                     padding: EdgeInsets.only(
//                         bottom: (editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'month'
//                             ? 8
//                             : 0),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           child: Row(
//                             children: <Widget>[
//                               Radio(
//                                   value: 'month',
//                                   groupValue:
//                                       editedMap.containsKey('everyDaySpan')
//                                           ? editedMap['everyDaySpan']
//                                           : activity.everyDaySpan,
//                                   onChanged: changeSchedulerType),
//                               Text(
//                                 '${AppString.get(context).every()} ${AppString.get(context).month()}',
//                                 style: Theme.of(context).textTheme.subtitle1,
//                               )
//                             ],
//                           ),
//                         ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'month' &&
//                             editedMap.containsKey('everyDaySpanValue'))
//                           MonthDaysView(
//                             enabledEntries:
//                                 editedMap['everyDaySpanValue'],
//                             containerWidth: constraint!.maxWidth - 42,
//                             isClickable: true,
//                             onDayClicked: changeSchedulerMonthDays,
//                           ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 'month' &&
//                             !editedMap.containsKey('everyDaySpanValue'))
//                           MonthDaysView(
//                             enabledEntries: activity.everyDaySpanValue,
//                             containerWidth: constraint!.maxWidth - 42,
//                             isClickable: true,
//                             onDayClicked: changeSchedulerMonthDays,
//                           ),
//                       ],
//                     ),
//                   ),
//                   //  Arbitrarily choice
//                   Container(
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             style: (editedMap.containsKey('everyDaySpan')
//                                         ? editedMap['everyDaySpan']
//                                         : activity.everyDaySpan) ==
//                                     null
//                                 ? BorderStyle.solid
//                                 : BorderStyle.none),
//                         borderRadius: BorderRadius.circular(5)),
//                     padding: EdgeInsets.only(
//                         bottom: (editedMap.containsKey('everyDaySpan')
//                                     ? editedMap['everyDaySpan']
//                                     : activity.everyDaySpan) ==
//                                 null
//                             ? 8
//                             : 0),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           child: Row(
//                             children: <Widget>[
//                               Radio(
//                                   value: null,
//                                   groupValue:
//                                       editedMap.containsKey('everyDaySpan')
//                                           ? editedMap['everyDaySpan']
//                                           : activity.everyDaySpan,
//                                   onChanged: changeSchedulerType),
//                               Text(
//                                 '${AppString.get(context).arbitrarily()}',
//                                 style: Theme.of(context).textTheme.subtitle1,
//                               )
//                             ],
//                           ),
//                         ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                 ? editedMap['everyDaySpan']
//                                 : activity.everyDaySpan) ==
//                             null)
//                           Container(
//                             margin:
//                                 EdgeInsets.only(bottom: 5, left: 5, right: 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   AppString.get(context).schedule(),
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: InkWell(
//                                     onTap: () async {
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) =>
//                                             _ScheduleChangePicker(
//                                           params,
//                                           activity,
//                                           updateWidget,
//                                           editedMap,
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       (editedMap
//                                                   .containsKey(
//                                                       'scheduleIntervalValue') &&
//                                               editedMap.containsKey(
//                                                   'scheduleIntervalUnit') &&
//                                               editedMap
//                                                   .containsKey('frequencyQty'))
//                                           ? '${AppString.get(context).every()} ${editedMap['scheduleIntervalValue'] as num} ${editedMap['scheduleIntervalUnit'] as String}  - ${editedMap['frequencyQty'] as num} ${AppString.get(context).times()}'
//                                           : (activity.scheduleIntervalValue !=
//                                                       null &&
//                                                   activity.scheduleIntervalUnit !=
//                                                       null &&
//                                                   activity.frequencyQty != null)
//                                               ? '${AppString.get(context).every()} ${activity.scheduleIntervalValue} ${activity.scheduleIntervalUnit}  - ${activity.frequencyQty} ${AppString.get(context).times()}'
//                                               : AppString.get(context)
//                                                   .selectSchedule(),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .subtitle1
//                                           .copyWith(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .secondary,
//                                               fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.end,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                 ? editedMap['everyDaySpan']
//                                 : activity.everyDaySpan) ==
//                             null)
//                           Container(
//                             margin: EdgeInsets.only(left: 5, right: 5, top: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   AppString.get(context).scheduledOn(),
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: InkWell(
//                                     onTap: () async {
//                                       await showDatePicker(
//                                         context: context,
//                                         initialDate: editedMap
//                                                 .containsKey('scheduledDate')
//                                             ? DateTime.parse(
//                                                     editedMap['scheduledDate'])
//                                                 .toLocal()
//                                             : activity.scheduledDate != null
//                                                 ? DateTime.parse(
//                                                         activity.scheduledDate)
//                                                     .toLocal()
//                                                 : DateTime.now().toLocal(),
//                                         firstDate: (editedMap.containsKey(
//                                                     'scheduledDate')
//                                                 ? DateTime.parse(editedMap[
//                                                         'scheduledDate'])
//                                                     .toLocal()
//                                                 : activity.scheduledDate != null
//                                                     ? DateTime.parse(activity
//                                                             .scheduledDate)
//                                                         .toLocal()
//                                                     : DateTime.now().toLocal())
//                                             .subtract(Duration(days: 60)),
//                                         lastDate: DateTime.now()
//                                             .add(Duration(days: 365)),
//                                       ).then((value) {
//                                         if (value == null) {
//                                           return;
//                                         }
//                                         changeScheduleOnDate(value);
//                                       }).catchError((error) {
//                                         print(error);
//                                       });
//                                     },
//                                     onLongPress: () => resetScheduleOnDate(),
//                                     child: Text(
//                                       editedMap.containsKey('scheduledDate')
//                                           ? DateFormat('d MMM yyyy').format(
//                                               DateTime.parse(editedMap[
//                                                       'scheduledDate'])
//                                                   .toLocal())
//                                           : activity.scheduledDate != null
//                                               ? DateFormat('d MMM yyyy').format(
//                                                   DateTime.parse(activity
//                                                           .scheduledDate)
//                                                       .toLocal())
//                                               : AppString.get(context)
//                                                   .selectDate(),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .subtitle1
//                                           .copyWith(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .secondary,
//                                               fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.end,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if ((editedMap.containsKey('everyDaySpan')
//                                 ? editedMap['everyDaySpan']
//                                 : activity.everyDaySpan) ==
//                             null)
//                           Container(
//                             margin: EdgeInsets.only(left: 5, right: 5, top: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text(
//                                   AppString.get(context).lastInterval(),
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                                 Text(
//                                   activity.lastRunDate == null
//                                       ? '-'
//                                       : DateFormat('d MMM yyyy').format(
//                                           DateTime.parse(activity.lastRunDate)
//                                               .toLocal()),
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Theme(
//               data: Theme.of(context).copyWith(
//                 buttonColor: showUpdate && canUpdate
//                     ? Theme.of(context).colorScheme.secondary
//                     : Theme.of(context).disabledColor,
//               ),
//               child: ElevatedButton(
//                 child: Text(
//                   AppString.get(context).update(),
//                   style: Theme.of(context)
//                       .textTheme
//                       .button
//                       .copyWith(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   primary: Theme.of(context).colorScheme.secondary,
//                 ),
//                 onPressed: showUpdate && canUpdate
//                     ? () {
//                         _updateScheduler(
//                             context, activity, editedMap, networkApi);
//                       }
//                     : null,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ScheduleChangePicker extends StatefulWidget {
//   final List<SchedulerParams> list;
//   final ActivitySchedulerItem activity;
//   final void Function() refreshParent;
//   final Map<String, dynamic> editedMap;

//   _ScheduleChangePicker(
//     this.list,
//     this.activity,
//     this.refreshParent,
//     this.editedMap,
//   );

//   @override
//   State createState() => _ScheduleChangePickerState();
// }

// class _ScheduleChangePickerState extends State<_ScheduleChangePicker> {
//   SchedulerParams currentSched, currentFreq;
//   TextEditingController schController, freqController;
//   bool initialized = false;

//   @override
//   void initState() {
//     super.initState();
//     String schedText, freqText;

//     schedText = widget.editedMap.containsKey('scheduleIntervalValue')
//         ? '${widget.editedMap['scheduleIntervalValue'] as num}'
//         : widget.activity.scheduleIntervalValue?.toString() ?? '';

//     freqText = widget.editedMap.containsKey('frequencyQty')
//         ? '${widget.editedMap['frequencyQty'] as num}'
//         : widget.activity.frequencyQty?.toString() ?? '';

//     schController = TextEditingController(text: schedText);
//     freqController = TextEditingController(text: freqText);

//     if (widget.list.isNotEmpty) {
//       if (widget.editedMap.containsKey('scheduleIntervalUnit')) {
//         try {
//           this.currentSched = widget.list[widget.list.indexWhere((element) =>
//               element.paramCode ==
//               widget.editedMap['scheduleIntervalUnit'] as String)];
//         } catch (e) {
//           this.currentSched = widget.list[0];
//         }
//       } else {
//         try {
//           this.currentSched = widget.list[widget.list.indexWhere((element) =>
//               element.paramCode == widget.activity.scheduleIntervalUnit)];
//         } catch (e) {
//           this.currentSched = widget.list[0];
//         }
//       }
//       if (widget.editedMap.containsKey('frequencyUnit')) {
//         try {
//           this.currentFreq = widget.list[widget.list.indexWhere((element) =>
//               element.paramCode ==
//               widget.editedMap['frequencyUnit'] as String)];
//         } catch (e) {
//           this.currentFreq = widget.list[0];
//         }
//       } else {
//         try {
//           this.currentFreq = widget.list[widget.list.indexWhere(
//               (element) => element.paramCode == widget.activity.frequencyUnit)];
//         } catch (e) {
//           this.currentFreq = widget.list[0];
//         }
//       }
//     }
//   }

//   void updateData(
//       String schedUnit, num schedQty, String freqUnit, num freqQty) {
//     widget.editedMap.update('scheduleIntervalUnit', (value) => schedUnit,
//         ifAbsent: () => schedUnit);
//     widget.editedMap.update('scheduleIntervalValue', (value) => schedQty,
//         ifAbsent: () => schedQty);
//     widget.editedMap
//         .update('frequencyUnit', (value) => freqUnit, ifAbsent: () => freqUnit);
//     widget.editedMap
//         .update('frequencyQty', (value) => freqQty, ifAbsent: () => freqQty);
//   }

//   @override
//   void dispose() {
//     schController.dispose();
//     freqController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: Card(
//           child: Padding(
//         padding: EdgeInsets.only(top: 8, left: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text(
//               AppString.get(context).schedule(),
//               style:
//                   Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                       autofocus: true,
//                       decoration: InputDecoration(
//                           labelText: AppString.get(context).every(),
//                           labelStyle: TextStyle(color: Colors.black)),
//                       keyboardType: TextInputType.numberWithOptions(
//                           decimal: false, signed: false),
//                       controller: schController,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Theme.of(context).colorScheme.secondary,
//                             width: 0.5,
//                             style: BorderStyle.solid),
//                         borderRadius: BorderRadius.circular(5)),
//                     child: DropdownButton<SchedulerParams>(
//                       underline: null,
//                       value: currentSched,
//                       items: widget.list
//                           .map((e) => DropdownMenuItem<SchedulerParams>(
//                                 value: e,
//                                 child: Text(
//                                   e.paramName?.toUpperCase() ?? '',
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                               ))
//                           .toList(),
//                       onChanged: (a) {
//                         setState(() {
//                           currentSched = a!;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: TextField(
//                 autofocus: true,
//                 keyboardType: TextInputType.numberWithOptions(
//                     decimal: false, signed: false),
//                 controller: freqController,
//                 decoration: InputDecoration(
//                     labelText: AppString.get(context).times(),
//                     labelStyle: TextStyle(color: Colors.black)),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     AppString.get(context).cancel(),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       updateData(
//                           currentSched.paramCode.toString(),
//                           int.parse(schController.text.trim().toString()),
//                           currentFreq.paramCode.toString(),
//                           int.parse(freqController.text.trim().toString()));
//                     });
//                     Navigator.of(context).pop();
//                     widget.refreshParent();
//                   },
//                   style: TextButton.styleFrom(
//                     textStyle: TextStyle(
//                       color: Theme.of(context).colorScheme.secondary,
//                     ),
//                   ),
//                   child: Text(
//                     AppString.get(context).change(),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }

// void _updateScheduler(BuildContext context, ActivitySchedulerItem activity,
//     Map<String, dynamic> editedMap) async {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return Util.getProgressDialog(context,
//             title: AppString.get(context).updating());
//       });

//   num active;
//   if (editedMap.containsKey('active')) {
//     active = editedMap['active'] as num;
//   } else {
//     active = activity.active;
//   }
//   num isAutoSchedulable;
//   if (editedMap.containsKey('isAutoSchedulable')) {
//     isAutoSchedulable = editedMap['isAutoSchedulable'] as num;
//   } else {
//     isAutoSchedulable = activity.isAutoSchedulable;
//   }

//   DateTime scheduledDate;
//   num scheduleIntervalValue, frequencyQty;
//   String scheduleIntervalUnit, frequencyUnit, everyDaySpan;
//   List<num> everyDaySpanValue;

//   if (editedMap.containsKey('everyDaySpan')) {
//     everyDaySpan = editedMap['everyDaySpan'];
//     switch (everyDaySpan) {
//       case 'day':
//         {
//           scheduledDate = null;
//           scheduleIntervalValue = null;
//           scheduleIntervalUnit = null;
//           frequencyQty = null;
//           frequencyUnit = null;
//           everyDaySpanValue = null;
//           break;
//         }
//       case 'week':
//       case 'month':
//         {
//           scheduledDate = null;
//           scheduleIntervalValue = null;
//           scheduleIntervalUnit = null;
//           frequencyQty = null;
//           frequencyUnit = null;
//           everyDaySpanValue = editedMap['everyDaySpanValue'];
//           break;
//         }
//       default:
//         {
//           scheduledDate = DateTime.parse(editedMap['scheduledDate'] as String);
//           scheduleIntervalValue = editedMap['scheduleIntervalValue'] as num;
//           scheduleIntervalUnit = editedMap['scheduleIntervalUnit'] as String;
//           frequencyQty = editedMap['frequencyQty'] as num;
//           frequencyUnit = editedMap['frequencyUnit'] as String;
//           everyDaySpan = null;
//           everyDaySpanValue = null;
//           break;
//         }
//     }
//   } else {
//     everyDaySpan = activity.everyDaySpan;
//     switch (everyDaySpan) {
//       case 'day':
//         {
//           scheduledDate = null;
//           scheduleIntervalValue = null;
//           scheduleIntervalUnit = null;
//           frequencyQty = null;
//           frequencyUnit = null;
//           everyDaySpanValue = null;
//           break;
//         }
//       case 'week':
//       case 'month':
//         {
//           scheduledDate = null;
//           scheduleIntervalValue = null;
//           scheduleIntervalUnit = null;
//           frequencyQty = null;
//           frequencyUnit = null;
//           if (editedMap.containsKey('everyDaySpanValue')) {
//             everyDaySpanValue = editedMap['everyDaySpanValue'];
//           } else {
//             everyDaySpanValue = activity.everyDaySpanValue;
//           }
//           break;
//         }
//       default:
//         {
//           if (editedMap.containsKey('scheduledDate')) {
//             scheduledDate =
//                 DateTime.parse(editedMap['scheduledDate'] as String);
//           } else {
//             scheduledDate = DateTime.parse(activity.scheduledDate);
//           }

//           if (editedMap.containsKey('scheduleIntervalValue')) {
//             scheduleIntervalValue = editedMap['scheduleIntervalValue'] as num;
//           } else {
//             scheduleIntervalValue = activity.scheduleIntervalValue;
//           }

//           if (editedMap.containsKey('scheduleIntervalUnit')) {
//             scheduleIntervalUnit = editedMap['scheduleIntervalUnit'] as String;
//           } else {
//             scheduleIntervalUnit = activity.scheduleIntervalUnit;
//           }

//           if (editedMap.containsKey('frequencyQty')) {
//             frequencyQty = editedMap['frequencyQty'] as num;
//           } else {
//             frequencyQty = activity.frequencyQty;
//           }

//           if (editedMap.containsKey('frequencyUnit')) {
//             frequencyUnit = editedMap['frequencyUnit'] as String;
//           } else {
//             frequencyUnit = activity.frequencyUnit;
//           }
//           everyDaySpan = null;
//           everyDaySpanValue = null;
//           break;
//         }
//     }
//   }

//   try {
//     var response = await networkApi.updateActivitySchedulerItem(
//       context: context,
//       id: activity.schedulerId.toInt(),
//       schDate: scheduledDate,
//       schIntervalValue: scheduleIntervalValue,
//       schIntervalUnit: scheduleIntervalUnit,
//       freqValue: frequencyQty,
//       freqUnit: frequencyUnit,
//       active: active,
//       everyDaySpan: everyDaySpan,
//       everyDaySpanValue: everyDaySpanValue,
//       autoSchedulable: isAutoSchedulable,
//     );

//     Navigator.of(context).pop();
//     if (response.status) {
//       showDialog(
//           context: context,
//           builder: (b) => Util.getAlertDialog(
//                   context, AppString.get(context).message(), response.message,
//                   positiveButton: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               }));
//     } else {
//       showDialog(
//           context: context,
//           builder: (b) => Util.getAlertDialog(
//               context, AppString.get(context).message(), response.message));
//     }
//   } catch (e) {
//     Navigator.of(context).pop();
//     showDialog(
//         context: context,
//         builder: (b) => Util.getAlertDialog(
//             context, AppString.get(context).message(), e.toString()));
//   }
// }
