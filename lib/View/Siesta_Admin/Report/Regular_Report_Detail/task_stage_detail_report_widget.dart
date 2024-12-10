import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduled_activities_model.dart';
import 'package:siestaamsapp/Model/Report_Model/taskStage_Model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/scheduled_activities_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../Provider/app_language_provider.dart';

class TaskStageDetailReportPage extends StatefulWidget {
  final dynamic data;

  TaskStageDetailReportPage({Key? key, required this.data}) : super(key: key);

  @override
  _TaskStageDetailReportPageState createState() =>
      _TaskStageDetailReportPageState();
}

class _TaskStageDetailReportPageState extends State<TaskStageDetailReportPage> {
  late Data _stage;
  late List<Data> _stageList;
  String? _currentAppLang;
  late Future<void> fetchDataFuture;
  String? propertyNumber;
  String? schedulerId;
  List<dynamic> data = [];

  num bNavIndex = 0;
  bool showFilterView = false;
  bool canViewReport = false,
      canAddSchedTask = false,
      canViewNotfRequests = false;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  TextEditingController? _searchController;
  bool isSearchShows = false;
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
    print(appLanguageProvider.getCurrentAppLanguage.toString());
    currentAppLanguage = appLanguageProvider.getCurrentAppLanguage.toString();
    fetchDataFuture = fetchData(); // Call the API only once

    _stage = widget.data['stage'];
    _stageList = widget.data['stageList'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final scheduledActivitiesViewmodel =
          Provider.of<ScheduledActivitiesViewmodel>(context, listen: false);

      scheduledActivitiesViewmodel
          .fetchScheduledActivitiesApi(token.toString(),currentAppLanguage);
    });
  }

  Widget createExpansionTiles(BuildContext context,
      List<ScheduledActivities> dataList, String desiredExecutionStatus) {
    List<ScheduledActivities> filteredData = dataList
        .where((activity) =>
            activity.executionStatus?.toLowerCase() ==
            desiredExecutionStatus.toLowerCase())
        .toList();

    if (desiredExecutionStatus.toLowerCase() == "delayed") {
      filteredData = dataList
          .where((activity) =>
              (activity.executionStatus?.toLowerCase() == "incomplete" ||
                  (activity.executionStatus?.toLowerCase() == "active" &&
                      getActivityExecutionStatusColor(
                              status: activity.propertyNumber.toString(),
                              createdDate: activity.createdDateUTC.toString(),
                              deadlineDate: activity.delayDeadline,
                              desiredExecutionStatus: desiredExecutionStatus) ==
                          Colors.redAccent.shade400)))
          .toList();
    } else {
      // Filter data by desired executionStatus
      filteredData = dataList
          .where((activity) =>
              activity.executionStatus?.toLowerCase() ==
              desiredExecutionStatus.toLowerCase())
          .toList();
    }

    // Group data by propertyNumber
    Map<String, List<ScheduledActivities>> groupedData = {};
    for (ScheduledActivities data in filteredData) {
      if (!groupedData.containsKey(data.propertyNumber)) {
        groupedData[data.propertyNumber!] = [];
      }
      groupedData[data.propertyNumber!]!.add(data);
    }

    // Create ExpansionTile widgets
    List<Widget> expansionTiles = [];
    groupedData.forEach((propertyNumber, activities) {
      List<Widget> activityTiles = [];

      activities.forEach((activity) {
        Color statusColor = getActivityExecutionStatusColor(
          status: activity.propertyNameTranslation?.toUpperCase() ??
              activity.propertyName?.toUpperCase() ??
              activity.propertyNumber!.toUpperCase(),
          createdDate: activity.createdDateUTC.toString(),
          deadlineDate: activity.delayDeadline,
          desiredExecutionStatus:
              desiredExecutionStatus, // Pass the desiredExecutionStatus here
        );
        activityTiles.add(
          GestureDetector(
            onTap: () {
              Map data1 = {
                'schedulerId': activity.schedulerId.toString(),
                'activityNameTranslation':
                    activity.activityNameTranslation.toString(),
                'slipNo': activity.slipNo.toString(),
                'propertyNameTranslation':
                    activity.propertyNameTranslation.toString(),
                'propertyName': activity.propertyName.toString(),
                'propertyNumber': propertyNumber.toString(),
              };

              Navigator.pushNamed(context, RoutesName.scheduledTaskDetail,
                  arguments: data1);
            },
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
                                  style:
                                      TextStyle(fontSize: descriptionFontSize),
                                ),
                              ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(children: [
                                    if (activity.executionStatus!
                                            .toLowerCase() ==
                                        'completed')
                                      TextSpan(
                                        text: '(' +
                                            timeago.format(
                                                DateTime.now().subtract(
                                                  DateTime.parse(activity
                                                          .completedOn
                                                          .toString())
                                                      .difference(
                                                    DateTime.parse(
                                                      activity.startedOn
                                                          .toString(),
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
                                          activity.executionStatus!
                                              .toUpperCase(),
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
                                        DateTime.parse(activity.delayDeadline
                                                .toString())
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
                                          DateTime.parse(activity.createdDateUTC
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
                                                activity.completedOn!
                                                        .trim()
                                                        .length <=
                                                    0)
                                            ? '---'
                                            : intl.DateFormat('d MMM yyyy')
                                                .format(
                                                DateTime.parse(activity
                                                        .completedOn
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
          ),
        );
      });

      expansionTiles.add(
        ExpansionTile(
            tilePadding: EdgeInsets.fromLTRB(12, 0, 8, 12),
            title: Container(
              padding: EdgeInsets.only(left: 8),
              height: 7.h,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(propertyNumber),
                ],
              ),
            ),
            children: activityTiles),
      );
    });

    return Column(children: expansionTiles);
  }

  @override
  Widget build(BuildContext context) {
    final scheduledActivitiesViewmodel =
        Provider.of<ScheduledActivitiesViewmodel>(context);

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
                '${AppString.get(context).stage()}: ',
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
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<Data>(
                      value: _stage,
                      items: _stageList
                          .map(
                            (e) => DropdownMenuItem(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text( e.translation != null ?
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
                ),
              ),
            ],
          ),
        ),
        actions: [],
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
            return ChangeNotifierProvider<ScheduledActivitiesViewmodel>.value(
              value: scheduledActivitiesViewmodel,
              child: Consumer<ScheduledActivitiesViewmodel>(
                builder: (context, value, _) {
                  switch (value.scheduledActivitiesList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.scheduledActivitiesList.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {},
                          loadingText:
                              value.scheduledActivitiesList.message.toString(),
                        );
                      } else {
                        // Navigate to LoginScreen and remove all previous routes
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        });
                        // Return an empty container while navigating
                        return Container();
                      }

                    case Status.COMPLETED:
                      print("value.scheduledActivitiesList.data!.data!.length");
                      print(value.scheduledActivitiesList.data!.data!.length);
                      return Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: 8, bottom: 64),
                                  itemBuilder: (context, index) {
                                    return createExpansionTiles(
                                        context,
                                        value.scheduledActivitiesList.data!
                                            .data!,
                                        _stage.executionStageCode
                                            .toString()
                                            .toLowerCase());
                                  },
                                  itemCount: 1,
                                ),
                              ),
                            ],
                          ));
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  void changeStage(Data? stage) {
    setState(() {
      _stage = stage!;
      fetchDataFuture = fetchData(); // Call the API only once

      print('_stage');
      print(_stage.executionStageName);
      print(_stage.executionStageCode);
      print('_stage');
    });
  }
}
