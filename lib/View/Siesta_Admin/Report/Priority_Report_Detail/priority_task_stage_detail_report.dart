import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Report_Model/activity_groups.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTask.dart';
import 'package:siestaamsapp/Model/Report_Model/priorityTaskDetails.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';
import 'package:siestaamsapp/View_Model/Report_View_Model/priorityTaskDetails_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../Provider/app_language_provider.dart';

class PriorityTaskStageDetailReportPage extends StatefulWidget {
  final dynamic data;

  PriorityTaskStageDetailReportPage({Key? key, required this.data})
      : super(key: key);

  @override
  _TaskStageDetailReportPageState createState() =>
      _TaskStageDetailReportPageState();
}

class _TaskStageDetailReportPageState
    extends State<PriorityTaskStageDetailReportPage> {
  late PriorityTask _stage;
  late List<PriorityTask> _stageList;
  late ActivityGroups _group;
  late String _currentAppLang;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  var childKey = GlobalKey<_TaskStageDetailReportBodyState>();
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

    _stage = widget.data['stage'];
    _stageList = widget.data['stageList'];
    _group = widget.data['activityGroup'];
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final priorityTaskDetailsViewmodel =
          Provider.of<PriorityTaskDetailsViewmodel>(context, listen: false);

      priorityTaskDetailsViewmodel.fetchPriorityTaskDetailsApi(
          _stage.executionStageCode.toString(),
          _group.code.toString(),
          token.toString(),currentAppLanguage);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        leading: BackButton(color: Colors.white),
        title: Text(
          AppString.get(context).activityStagesReport(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Text(
                '${AppString.get(context).stage()}:',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
                child: DropdownButton<PriorityTask>(
                  value: _stage,
                  underline: Container(),
                  items: _stageList
                      .map(
                        (e) => DropdownMenuItem(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              // e.translation != null
                              //     ? ActivityTranslation.fromJson(
                              //             e.translation[_currentAppLang])
                              //         .title
                              //     :

                              e.translation != null ?
                                  currentAppLanguage == "guj"
                                      ? e.translation!.guj!.title.toString()
                                      : e.translation!.eng!.title.toString() : e.executionStageName.toString(),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: changeStage,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => childKey.currentState!.changeCurrentStage(_stage),
          ),
        ],
      ),
      body: _TaskStageDetailReportBody(
          key: childKey, currentStage: _stage, group: _group),
    );
  }

  void changeStage(PriorityTask? stage) {
    setState(() {
      _stage = stage!;
      childKey.currentState!.changeCurrentStage(_stage);
      fetchDataFuture = fetchData(); // Call the API only once
    });
  }
}

class _TaskStageDetailReportBody extends StatefulWidget {
  final PriorityTask? currentStage;
  final ActivityGroups? group;

  _TaskStageDetailReportBody({Key? key, this.currentStage, this.group})
      : super(key: key);

  @override
  _TaskStageDetailReportBodyState createState() {
    return _TaskStageDetailReportBodyState();
  }
}

class _TaskStageDetailReportBodyState
    extends State<_TaskStageDetailReportBody> {
  late PriorityTask _currentStage;
  dynamic _errorPageStatus;
  List<ExpansionEntry> processedList = [];
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
    _currentStage = widget.currentStage!;
    fetchDataFuture = fetchData(); // Call the API only once
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
              AppLanguageProvider appLanguageProvider =
        Provider.of<AppLanguageProvider>(context, listen: false);

        currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();

      final priorityTaskDetailsViewmodel =
          Provider.of<PriorityTaskDetailsViewmodel>(context, listen: false);

      priorityTaskDetailsViewmodel.fetchPriorityTaskDetailsApi(
          _currentStage.executionStageCode.toString(),
          widget.group!.code.toString(),
          token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priorityTaskDetailsViewmodel =
        Provider.of<PriorityTaskDetailsViewmodel>(context, listen: false);
    return FutureBuilder<void>(
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
          return ChangeNotifierProvider<PriorityTaskDetailsViewmodel>.value(
            value: priorityTaskDetailsViewmodel,
            child: Consumer<PriorityTaskDetailsViewmodel>(
              builder: (context, value, _) {
                switch (value.priorityTaskDetailsList.status!) {
                  case Status.LOADING:
                    return Center(child: CircularProgressIndicator());

                  case Status.ERROR:
                    if (value.priorityTaskDetailsList.message ==
                        "No Internet Connection") {
                      return ErrorScreenWidget(
                        onRefresh: () async {
                          fetchData();
                        },
                        loadingText:
                            value.priorityTaskDetailsList.message.toString(),
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
                    List<ScheduledActivitiesDetails> list =
                        value.priorityTaskDetailsList.data!.data!;
                    _resetExpandedList(list);

                    return Container(
                      color: Colors.grey.shade200,
                      child:
                          value.priorityTaskDetailsList.data!.data!.length > 0
                              ? ListView.builder(
                                  padding: EdgeInsets.only(top: 8, bottom: 64),
                                  itemBuilder: (c, i) => ExpandedItem(
                                    processedList[i],
                                    initiallyExpanded: false,
                                  ),
                                  itemCount: processedList.length,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        'asset/images/empty_pocket_man.svg',
                                        height: 200,
                                        width: 200,
                                        semanticsLabel: 'Placeholder',
                                      ),
                                    ),
                                    Text(AppString.get(context).emptyData(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(fontSize: 18)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                    );
                }
              },
            ),
          );
        }
      },
    );
  }

  void changeCurrentStage(PriorityTask stage) {
    _currentStage = stage;
    fetchDataFuture = fetchData(); // Call the API only once
  }

  void _reloadData() {
    setState(() {
      fetchDataFuture = fetchData(); // Call the API only once
    });
  }

  void _resetExpandedList(List<ScheduledActivitiesDetails> list) {
    processedList.clear();
    Map<String, List<ScheduledActivitiesDetails>> map = {};
    list.forEach((value) {
      String key = value.propertyNameTranslation?.toUpperCase() ??
          value.propertyNameTranslation?.toUpperCase() ??
          value.propertyNumber!.toUpperCase();
      if (map.containsKey(key)) {
        List<ScheduledActivitiesDetails> list = map[key] ?? [];
        list.add(value);
        map[key] = list;
      } else {
        List<ScheduledActivitiesDetails> list = [value];
        map.putIfAbsent(key, () {
          return list;
        });
      }
    });
    map.forEach((String key, List<ScheduledActivitiesDetails> children) {
      List<ExpansionEntry> tempChildrenList = [];
      children.forEach((value) {
        tempChildrenList.add(ExpansionEntry(_TaskItem(value, _reloadData)));
      });
      var tempEntry = ExpansionEntry(
        Container(
          height: 75,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      key,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: headerFontSize,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${tempChildrenList.length} ${AppString.get(context).activities()}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        children: tempChildrenList,
      );
      processedList.add(tempEntry);
    });
  }
}

class _TaskItem extends StatelessWidget {
  final ScheduledActivitiesDetails activity;
  final VoidCallback requestRefresh;

  _TaskItem(this.activity, this.requestRefresh, {Key? key}) : super(key: key);

  void _openTaskItemDetail(BuildContext context) {
    Map data1 = {
      'schedulerId': activity.schedulerId.toString(),
      'activityNameTranslation':
          activity.activityNameTranslation ?? activity.activityName.toString(),
      'slipNo': activity.slipNo.toString(),
      'propertyNameTranslation': activity.propertyNameTranslation.toString(),
      'propertyName': activity.propertyName.toString(),
      'propertyNumber': activity.propertyNumber.toString(),
    };

    Navigator.pushNamed(context, RoutesName.scheduledTaskDetail,
        arguments: data1);
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Util.getActivityExecutionStatusColor(
      status: activity.executionStatus.toString(),
      createdDate: activity.createdDateUTC.toString(),
      deadlineDate: activity.delayDeadline,
    );

    return GestureDetector(
      onTap: () => _openTaskItemDetail(context),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(8, 0, 8, 15),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      if (activity.groupCode != 'reg')
                        Container(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                          padding: EdgeInsets.all(3),
                          child: Text(
                            '${AppString.get(context).maintenanceTask()}',
                            style: TextStyle(fontSize: descriptionFontSize),
                          ),
                        ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(children: [
                              if (activity.executionStatus!.toLowerCase() ==
                                  'completed')
                                TextSpan(
                                  text: '(' +
                                      timeago.format(
                                          DateTime.now().subtract(
                                            DateTime.parse(activity.completedOn
                                                    .toString())
                                                .difference(
                                              DateTime.parse(
                                                activity.startedOn.toString(),
                                              ),
                                            ),
                                          ),
                                          locale: 'en_short') +
                                      ')',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: subDescriptionFontSize),
                                ),
                              TextSpan(
                                text: activity.executionStatusTranslation
                                        ?.toUpperCase() ??
                                    activity.executionStatus!.toUpperCase(),
                                style: TextStyle(
                                    color: statusColor,
                                    fontSize: descriptionFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            activity.activityNameTranslation ??
                                activity.activityName.toString(),
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: titleFontSize,
                            ),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    if (activity.groupCode != 'reg')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              AppString.get(context).delayDeadline(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.arrow_right_alt,
                              color: appSecondaryColor,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.arrow_right_alt,
                              color: appSecondaryColor,
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.arrow_right_alt,
                              color: appSecondaryColor,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                intl.DateFormat('d MMM yyyy').format(
                                  DateTime.parse(
                                          activity.delayDeadline.toString())
                                      .toLocal(),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          )
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'asset/images/hand_start_line.svg',
                                  height: 24,
                                  width: 24,
                                  colorBlendMode: BlendMode.srcATop,
                                  semanticsLabel: 'Placeholder',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  intl.DateFormat('d MMM yyyy').format(
                                    DateTime.parse(
                                            activity.createdDateUTC.toString())
                                        .toLocal(),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subDescriptionFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: appSecondaryColor,
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: appSecondaryColor,
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: appSecondaryColor,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'asset/images/hand_finish_line.svg',
                                  fit: BoxFit.cover,
                                  height: 24,
                                  width: 24,
                                  colorBlendMode: BlendMode.srcATop,
                                  semanticsLabel: 'Placeholder',
                                ),
                              ),
                              SizedBox(width: 5),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  (activity.completedOn == null ||
                                          activity.completedOn!.trim().length <=
                                              0)
                                      ? '---'
                                      : intl.DateFormat('d MMM yyyy').format(
                                          DateTime.parse(activity.completedOn
                                                  .toString())
                                              .toLocal(),
                                        ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subDescriptionFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  bool isPriorityTask() {
    return activity.groupCode != 'reg';
  }
}
