import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Dashboard_model/scheduledById_activities_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Utils;
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/images_slider_list.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Dashboard/list_item.dart';
import 'package:siestaamsapp/View/file_upload/bloc/file_upload_bloc.dart';
import 'package:siestaamsapp/View/file_upload/bloc/upload_model.dart';
import 'package:siestaamsapp/View/file_upload/file_upload_widget.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/scheduled_activitiesById_view_model.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/updateScheduled_Task_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';

import '../../../Provider/app_language_provider.dart';

class ScheduledTaskDetail extends StatefulWidget {
  final dynamic data;

  const ScheduledTaskDetail({super.key, required this.data});

  @override
  State<ScheduledTaskDetail> createState() => _ScheduledTaskDetailState();
}

class _ScheduledTaskDetailState extends State<ScheduledTaskDetail> {
  late Future<void> fetchDataFuture;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  String? schedulerId;
  late String startedOn, completedOn;
  late bool canEdit;
  bool _refreshDashboardTasks = false;
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

    AuthModal authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
    canEdit = authModal.canUpdate!.contains(moduleScheduledActivity);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final scheduledActivitiesViewmodel =
          Provider.of<ScheduledActivitiesByIdByIdViewmodel>(context,
              listen: false);

      scheduledActivitiesViewmodel.fetchScheduledActivitiesByIdApi(
          widget.data['schedulerId'].toString(), token.toString(),currentAppLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduledActivitiesByIdByIdViewmodel =
        Provider.of<ScheduledActivitiesByIdByIdViewmodel>(context);

    String subtitle =
        '${AppString.get(context).plot()}: ${widget.data['propertyNumber']}';
    // '${AppString.get(context).plot()}: ${widget.data['slipNo'] ?? 'XXXX'}';

    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(_refreshDashboardTasks);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.photo_library, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        AppString.get(context).history(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.assignment, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        AppString.get(context).detail(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.data['activityNameTranslation'].toString(),
                    style: TextStyle(fontSize: 13.sp, color: Colors.white)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: titleFontSize, color: Colors.white)),
              ],
            ),
            actions: <Widget>[
              BlocBuilder<FileUploadBloc, FileUploadState>(
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case FileUploadRunningState:
                      {
                        return Container(
                          height: Theme.of(context).buttonTheme.height,
                          width: Theme.of(context).buttonTheme.height,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.cloud_upload,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileUploadsList()));
                                  }),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 0),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: appSecondaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }
                    case IdleState:
                    default:
                      {
                        return Container(width: 0, height: 0);
                      }
                  }
                },
              ),
              IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => {fetchDataFuture = fetchData()})
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
                // Render the UI with the fetched data
                return ChangeNotifierProvider<
                    ScheduledActivitiesByIdByIdViewmodel>.value(
                  value: scheduledActivitiesByIdByIdViewmodel,
                  child: Consumer<ScheduledActivitiesByIdByIdViewmodel>(
                    builder: (context, value, _) {
                      switch (value.scheduledActivitiesByIdList.status!) {
                        case Status.LOADING:
                          return Center(child: CircularProgressIndicator());

                        case Status.ERROR:
                          if (value.scheduledActivitiesByIdList.message ==
                              "No Internet Connection") {
                            return ErrorScreenWidget(
                              onRefresh: () async {
                                fetchData();
                              },
                              loadingText: value
                                  .scheduledActivitiesByIdList.message
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
                          startedOn = value.scheduledActivitiesByIdList.data!
                                      .data!.startedOn ==
                                  null
                              ? AppString.get(context).notStartedYet()
                              : DateFormat('d MMM yyyy - h:mm a').format(
                                  DateTime.parse(value
                                          .scheduledActivitiesByIdList
                                          .data!
                                          .data!
                                          .startedOn)
                                      .toLocal());
                          completedOn = value.scheduledActivitiesByIdList.data!
                                      .data!.completedOn ==
                                  null
                              ? AppString.get(context).notCompletedYet()
                              : DateFormat('d MMM yyyy - h:mm a').format(
                                  DateTime.parse(value
                                          .scheduledActivitiesByIdList
                                          .data!
                                          .data!
                                          .completedOn)
                                      .toLocal());

                          bool showAction = canEdit &&
                              value.scheduledActivitiesByIdList.data!.data!
                                      .stageActions !=
                                  null &&
                              value.scheduledActivitiesByIdList.data!.data!
                                      .stageActions!.length >
                                  0;
                          print(
                              'showActionshow;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;showActionshowActionshowAction');
                          print(showAction);
                          print(
                              'showActionshow;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;showActionshowActionshowAction');

                          return TabBarView(
                            children: [
                              Container(
                                color: Colors.grey.shade200,
                                padding: EdgeInsets.all(8),
                                child: ListView.builder(
                                  itemCount: (value
                                              .scheduledActivitiesByIdList
                                              .data!
                                              .data!
                                              .stageHistory
                                              ?.length ??
                                          0) +
                                      (showAction ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (showAction && index == 0)
                                      return Container(
                                        child: _UpdateActionGroup(
                                            value.scheduledActivitiesByIdList
                                                .data!.data!,
                                            fetchData,
                                            _updateRefreshVars),
                                      );
                                    return _ImageSliderClass(
                                        value.scheduledActivitiesByIdList.data!
                                            .data!,
                                        value.scheduledActivitiesByIdList.data!
                                                .data!.stageHistory!.reversed
                                                .toList()[
                                            showAction ? index - 1 : index],
                                        value.scheduledActivitiesByIdList.data!
                                            .data!.executionStatus
                                            .toString(),
                                        canEdit);
                                  },
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraint) {
                                  return Container(
                                    width: constraint.maxWidth,
                                    height: constraint.maxHeight,
                                    color: Colors.grey.shade200,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Card(
                                                elevation: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Table(
                                                    columnWidths: {
                                                      0: IntrinsicColumnWidth(),
                                                      1: IntrinsicColumnWidth(),
                                                      2: IntrinsicColumnWidth(
                                                          flex: 1),
                                                    },
                                                    children: [
                                                      TableRow(children: [
                                                        Text(
                                                            AppString.get(
                                                                    context)
                                                                .activity(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    titleFontSize)),
                                                        Text(
                                                          ' : ',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        ),
                                                        Text(
                                                          scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .activityName
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        )
                                                      ]),
                                                      TableRow(children: [
                                                        Text(
                                                          AppString.get(context)
                                                              .slip(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        ),
                                                        Text(
                                                          ' : ',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        ),
                                                        widget.data['slipNo'] !=
                                                                "null"
                                                            ? Text(
                                                                (widget.data[
                                                                        'slipNo'] ??
                                                                    'XXXX'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        titleFontSize),
                                                              )
                                                            : Text(
                                                                ('XXXX'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        titleFontSize),
                                                              )
                                                      ]),
                                                      TableRow(children: [
                                                        Text(
                                                          AppString.get(context)
                                                              .instructions(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        ),
                                                        Text(
                                                          ' : ',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        ),
                                                        Text(
                                                          (
                                                              // scheduledActivitiesByIdByIdViewmodel
                                                              //   .scheduledActivitiesByIdList
                                                              //   .data!
                                                              //   .data!
                                                              //   .comments
                                                              //   .toString()
                                                              widget.data[
                                                                      'comments'] ??
                                                                  '-'),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSize),
                                                        )
                                                      ])
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Card(
                                              elevation: 2,
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppString.get(context)
                                                          .assignedTo(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      (scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .assignedToName ??
                                                          AppString.get(context)
                                                              .notAssigned()),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      AppString.get(context)
                                                          .assignedBy(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      (scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .assignedByName ??
                                                          '-'
                                                      // widget.activity.assignedByName ?? '-'
                                                      ),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      AppString.get(context)
                                                          .scheduledDate(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      DateFormat('d MMM yyyy')
                                                          .format(
                                                              DateTime.parse(
                                                        scheduledActivitiesByIdByIdViewmodel
                                                            .scheduledActivitiesByIdList
                                                            .data!
                                                            .data!
                                                            .createdDateUTC
                                                            .toString(),
                                                      ).toLocal()),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      AppString.get(context)
                                                          .status(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .executionStatusTranslation
                                                              ?.toUpperCase() ??
                                                          scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .executionStatus!
                                                              .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                            color: Utils
                                                                .getActivityExecutionStatusColor(
                                                              status: scheduledActivitiesByIdByIdViewmodel
                                                                  .scheduledActivitiesByIdList
                                                                  .data!
                                                                  .data!
                                                                  .executionStatus
                                                                  .toString(),
                                                              createdDate: scheduledActivitiesByIdByIdViewmodel
                                                                  .scheduledActivitiesByIdList
                                                                  .data!
                                                                  .data!
                                                                  .createdDateUTC
                                                                  .toString(),
                                                              deadlineDate:
                                                                  scheduledActivitiesByIdByIdViewmodel
                                                                      .scheduledActivitiesByIdList
                                                                      .data!
                                                                      .data!
                                                                      .delayDeadline,
                                                            ),
                                                          ),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      '${AppString.get(context).schedule()} ${AppString.get(context).type()}',
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .executionType
                                                              ?.toUpperCase() ??
                                                          '-',
                                                      // widget.activity.executionType?.toUpperCase() ?? '-',
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      AppString.get(context)
                                                          .startedOn(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      startedOn,
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                    Text(
                                                      AppString.get(context)
                                                          .completedOn(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              descriptionFontSize),
                                                    ),
                                                    Text(
                                                      completedOn,
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    if (scheduledActivitiesByIdByIdViewmodel
                                                            .scheduledActivitiesByIdList
                                                            .data!
                                                            .data!
                                                            .groupCode
                                                            .toString() !=
                                                        'reg')
                                                      Divider(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                      ),
                                                    if (scheduledActivitiesByIdByIdViewmodel
                                                            .scheduledActivitiesByIdList
                                                            .data!
                                                            .data!
                                                            .groupCode
                                                            .toString() !=
                                                        'reg')
                                                      Text(
                                                        AppString.get(context)
                                                            .delayDeadline(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                descriptionFontSize),
                                                      ),
                                                    if (scheduledActivitiesByIdByIdViewmodel
                                                            .scheduledActivitiesByIdList
                                                            .data!
                                                            .data!
                                                            .groupCode
                                                            .toString() !=
                                                        'reg')
                                                      Text(
                                                        DateFormat('d MMM yyyy')
                                                            .format(
                                                          DateTime.parse(scheduledActivitiesByIdByIdViewmodel
                                                                  .scheduledActivitiesByIdList
                                                                  .data!
                                                                  .data!
                                                                  .delayDeadline)
                                                              .toLocal(),
                                                        ),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Card(
                                              elevation: 2,
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Table(columnWidths: {
                                                  0: IntrinsicColumnWidth(),
                                                  1: IntrinsicColumnWidth(),
                                                  2: IntrinsicColumnWidth(
                                                      flex: 1),
                                                }, children: [
                                                  TableRow(children: [
                                                    Text(
                                                      AppString.get(context)
                                                          .plot(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Text(
                                                      ' : ',
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Text(
                                                      (scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .propertyName ??
                                                          AppString.get(context)
                                                              .notAssigned()
                                                      // widget.activity.propertyNumber ??
                                                      //   AppString.get(context).notAssigned()
                                                      ),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Text(
                                                      (AppString.get(context)
                                                          .dev()),
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Text(
                                                      ' : ',
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                    Text(
                                                      scheduledActivitiesByIdByIdViewmodel
                                                              .scheduledActivitiesByIdList
                                                              .data!
                                                              .data!
                                                              .propertyDevStageName ??
                                                          '-',
                                                      // widget.activity.propertyDevStageName ?? '-',
                                                      style: TextStyle(
                                                          fontSize:
                                                              titleFontSize),
                                                    ),
                                                  ]),
                                                ]),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Card(
                                              elevation: 2,
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Table(
                                                  columnWidths: {
                                                    0: IntrinsicColumnWidth(),
                                                    1: IntrinsicColumnWidth(),
                                                    2: IntrinsicColumnWidth(
                                                        flex: 1),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        AppString.get(context)
                                                            .owner(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        (widget.data[
                                                                'ownerName'] ??
                                                            AppString.get(
                                                                    context)
                                                                .notAssigned()),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        AppString.get(context)
                                                            .email(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        (widget.data[
                                                                'ownerEmail'] ??
                                                            '-'

                                                        //  widget.activity.ownerEmail ?? '-'
                                                        ),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        AppString.get(context)
                                                            .mobile(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        ' : ',
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                      Text(
                                                        (widget.data[
                                                                'ownerEmail'] ??
                                                            '-'

                                                        // widget.activity.ownerMobile != null
                                                        //   ? widget.activity.ownerMobile.truncate().toString()
                                                        //   : '-'

                                                        ),
                                                        style: TextStyle(
                                                            fontSize:
                                                                titleFontSize),
                                                      ),
                                                    ])
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                      }
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onRefresh() async {
    // setState(() {
    //   _status = Utils.PageStatus.PROGRESS;
    // });

    // networkApi
    //     .getScheduledTaskDetail(
    //   context: context,
    //   id: widget.activity.schedulerId.toInt(),
    // )
    //     .then((value) {
    //   if (value.status) {
    //     setState(() {
    //       _status = Utils.PageStatus.SUCCESS;
    //       activity = Activity.fromJson(value.data);
    //     });
    //   } else {
    //     setState(() {
    //       _status = Utils.PageStatus.ERROR;
    //       _errorTaskDetail = value.message;
    //     });
    //   }
    // }, onError: (error) {
    //   setState(() {
    //     _status = Utils.PageStatus.ERROR;
    //     _errorTaskDetail = Utils.getErrorMessage(context, error);
    //   });
    // });
  }
  void _updateRefreshVars() {
    _refreshDashboardTasks = true;
    print('updateRefreshvars called');
  }
  // Widget getContentWidget() {
  //   return  }
}

class _AdditionalInfoCard extends StatefulWidget {
  // final Activity activity;

  _AdditionalInfoCard({Key? key}) : super(key: key);

  @override
  State createState() => _AdditionalInfoCardState();
}

class _AdditionalInfoCardState extends State<_AdditionalInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Table(
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(flex: 1),
          },
          children: [
            TableRow(children: [
              Text(AppString.get(context).activity(),
                  style: TextStyle(fontSize: titleFontSize)),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                'Cleaning',
                // widget.activity.activ'ityNameTranslation ??
                //     widget.activity.activityName,
                style: TextStyle(fontSize: titleFontSize),
              )
            ]),
            TableRow(children: [
              Text(
                AppString.get(context).slip(),
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ('XXXX'
                // widget.activity.slipNo ?? 'XXXX'

                ),
                style: TextStyle(fontSize: titleFontSize),
              )
            ]),
            TableRow(children: [
              Text(
                AppString.get(context).instructions(),
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ('-'
                //  widget.activity.comments ?? '-'
                ),
                style: TextStyle(fontSize: titleFontSize),
              )
            ])
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_AdditionalInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
}

class _PropertyDetailCard extends StatefulWidget {
  // final Activity activity;

  _PropertyDetailCard({Key? key}) : super(key: key);

  @override
  State createState() => _PropertyDetailCardState();
}

class _PropertyDetailCardState extends State<_PropertyDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Table(columnWidths: {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(flex: 1),
        }, children: [
          TableRow(children: [
            Text(
              AppString.get(context).plot(),
              style: TextStyle(fontSize: titleFontSize),
            ),
            Text(
              ' : ',
              style: TextStyle(fontSize: titleFontSize),
            ),
            Text(
              ('P66'
              // widget.activity.propertyNumber ??
              //   AppString.get(context).notAssigned()
              ),
              style: TextStyle(fontSize: titleFontSize),
            ),
          ]),
          TableRow(children: [
            Text(
              (AppString.get(context).dev()),
              style: TextStyle(fontSize: titleFontSize),
            ),
            Text(
              ' : ',
              style: TextStyle(fontSize: titleFontSize),
            ),
            Text(
              '-',
              // widget.activity.propertyDevStageName ?? '-',
              style: TextStyle(fontSize: titleFontSize),
            ),
          ]),
        ]),
      ),
    );
  }

  @override
  void didUpdateWidget(_PropertyDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
}

class _OwnerDetailCard extends StatefulWidget {
  // final Activity activity;

  _OwnerDetailCard({Key? key}) : super(key: key);

  @override
  State createState() => _OwnerDetailCardState();
}

class _OwnerDetailCardState extends State<_OwnerDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Table(
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(flex: 1),
          },
          children: [
            TableRow(children: [
              Text(
                AppString.get(context).owner(),
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ('Not Assigned'
                // widget.activity.ownerName ??
                //   AppString.get(context).notAssigned()

                ),
                style: TextStyle(fontSize: titleFontSize),
              ),
            ]),
            TableRow(children: [
              Text(
                AppString.get(context).email(),
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ('-'

                //  widget.activity.ownerEmail ?? '-'
                ),
                style: TextStyle(fontSize: titleFontSize),
              ),
            ]),
            TableRow(children: [
              Text(
                AppString.get(context).mobile(),
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ' : ',
                style: TextStyle(fontSize: titleFontSize),
              ),
              Text(
                ('-'

                // widget.activity.ownerMobile != null
                //   ? widget.activity.ownerMobile.truncate().toString()
                //   : '-'

                ),
                style: TextStyle(fontSize: titleFontSize),
              ),
            ])
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_OwnerDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
}

class _UpdateActionGroup extends StatefulWidget {
  final ScheduledActivitiesById activity;
  final VoidCallback parentRefresh, updateRefreshVars;

  _UpdateActionGroup(this.activity, this.parentRefresh, this.updateRefreshVars);

  @override
  State<StatefulWidget> createState() => _UpdateActionGroupState();
}

class _UpdateActionGroupState extends State<_UpdateActionGroup> {
  String? _comment;
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
  }

  @override
  void didUpdateWidget(_UpdateActionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(AppString.get(context).actions(),
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 5),
                Table(
                  defaultColumnWidth: IntrinsicColumnWidth(flex: 1),
                  children: getActionRows(
                    context,
                    widget.activity.stageActions!,
                  ),
                ),
              ],
            ),
            // Positioned.fill(
            //   child: Container(
            //     color: Colors.white.withOpacity(0.85),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  List<TableRow> getActionRows(
      BuildContext context, List<StageActions> actions) {
    return List.generate(
      (actions.length / 2).ceil(),
      (index) => TableRow(
        children: [
          Container(
            margin: EdgeInsets.only(right: 4),
            child: ElevatedButton(
              onPressed: () {
                var actionId = actions[index * 2].id;
                actions[index * 2].isCommentRequired == 1
                    ? openCommentBottomSheet(actionId.toString())
                    : updateActivityStatus(actionId.toString());
              },
              style: ElevatedButton.styleFrom(
                primary: appSecondaryColor,
              ),
              child: Text(
                actions[index * 2].name.toString(),
                style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 16),
              ),
            ),
          ),
          index == (actions.length / 2).ceil()
              ? Container(
                  margin: EdgeInsets.only(left: 4),
                )
              : Container(
                  margin: EdgeInsets.only(left: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      var actionId = actions[index * 2 + 1].id;
                      actions[index * 2 + 1].isCommentRequired == 1
                          ? openCommentBottomSheet(actionId.toString())
                          : updateActivityStatus(actionId.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: appSecondaryColor,
                    ),
                    child: Text(
                      actions[index * 2 + 1].name.toString(),
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                          ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  void updateActivityStatus(String status, [String? comment]) {
    final updatescheduledTaskViewModel =
        Provider.of<UpdatescheduledTaskViewModel>(context, listen: false);

    Map data = {
      "status": status.toString(),
      "comment": comment.toString(),
    };

    updatescheduledTaskViewModel.updatescheduledTaskApi(
        widget.activity.schedulerId.toString(),
        token.toString(),
        data,
        context);
  }

  void openCommentBottomSheet(String actionId) {
    _comment = null;
    showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: AppString.get(context).comment(),
                  labelText: AppString.get(context).comment(),
                ),
                onFieldSubmitted: (value) {
                  Navigator.of(context).pop(value.trim());
                },
                onChanged: (value) => _comment = value,
                autofocus: true,
                maxLength: 500,
                onSaved: (value) {
                  Navigator.of(context).pop(value!.trim());
                },
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: OutlinedButton(
                        child: Text(
                          AppString.get(context).cancel(),
                          style: Theme.of(context).textTheme.button?.copyWith(
                                color: appSecondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        AppString.get(context).confirm(),
                        style: Theme.of(context).textTheme.button?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: appSecondaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(_comment?.trim());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      isDismissible: true,
    ).then((value) {
      if (value == null) {
        return;
      }
      updateActivityStatus(actionId, value);
    });
  }
}

class _ImageSliderClass extends StatefulWidget {
  final ScheduledActivitiesById activity;
  final StageHistory history;
  final String currentStage;
  final bool canEdit;

  _ImageSliderClass(
      this.activity, this.history, this.currentStage, this.canEdit,
      {Key? key})
      : super(key: key);

  @override
  State createState() => _ImageSliderClassState();
}

class _ImageSliderClassState extends State<_ImageSliderClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num imagesCount = widget.history.images?.length ?? 0;
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Card(
        child: Column(
          children: [
            imagesCount > 3
                ? CarouselSlider.builder(
                    itemCount: imagesCount.toInt(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                    ),
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return CachedNetworkImage(
                        imageUrl: widget.history.images![index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            decoration: BoxDecoration(
                              color: imagesCount < 1
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                            padding: EdgeInsets.all(16),
                            child: imagesCount < 1
                                ? Container(
                                    child: Center(
                                      child: Text(
                                          AppString.get(context).emptyData()),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'asset/images/image_placeholder.svg',
                                    colorBlendMode: BlendMode.srcATop,
                                    color: Colors.grey,
                                    semanticsLabel: 'Placeholder',
                                  ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.all(5),
                            child: SvgPicture.asset(
                              'asset/images/error.svg',
                              height: 100,
                              width: 100,
                              colorBlendMode: BlendMode.srcATop,
                              color: Colors.grey,
                              semanticsLabel: 'Placeholder',
                            ),
                          );
                        },
                      );
                    },
                  )
                : imagesCount > 0
                    ? Container(
                        height: (MediaQuery.of(context).size.height / 4),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: LayoutBuilder(builder: (context, constraint) {
                            return Row(
                              children: <Widget>[
                                for (num i = 0; i < imagesCount; i++)
                                  Container(
                                    width: constraint.maxWidth / imagesCount,
                                    padding: EdgeInsets.all(1),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.history.images![i.toInt()],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300),
                                          padding: EdgeInsets.all(16),
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'asset/images/image_placeholder.svg',
                                                height: 100,
                                                width: 100,
                                                colorBlendMode:
                                                    BlendMode.srcATop,
                                                color: Colors.grey,
                                                semanticsLabel: 'Placeholder',
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child:
                                                    LinearProgressIndicator(),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, obj) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300),
                                          padding: EdgeInsets.all(16),
                                          margin: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            'asset/images/error.svg',
                                            height: 100,
                                            width: 100,
                                            colorBlendMode: BlendMode.srcATop,
                                            color: Colors.grey,
                                            semanticsLabel: 'Placeholder',
                                          ),
                                        );
                                      },
                                    ),
                                  )
                              ],
                            );
                          }),
                        ),
                      )
                    : Container(height: 0, width: 0),

            SizedBox(height: 10), // Adjust spacing as needed
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${AppString.get(context).status()}: ${widget.history.stageTranslation?.toUpperCase() ?? widget.history.stageId?.toUpperCase()}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Utils.getActivityExecutionStatusColor(
                              status: widget.history.stageId.toString(),
                              createdDate:
                                  DateTime.now().toLocal().toIso8601String(),
                              deadlineDate: widget.activity.delayDeadline,
                            ),
                          ),
                    ),
                  ),
                  Text(
                      '${AppString.get(context).date()}: ${DateFormat('d MMM yyyy hh:mm a').format(DateTime.parse(widget.history.createdDateUtc.toString()).toLocal())}',
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  '${AppString.get(context).by()}: ${widget.history.createdBy ?? '-'}',
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  '${AppString.get(context).comment()}: ${widget.history.comments ?? '-'}',
                  style: Theme.of(context).textTheme.subtitle1),
            ),
            if (widget.activity.isImageRequired! <= 0) SizedBox(height: 8),
           if (widget.activity.isImageRequired! > 0) Container( margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5), child: Row( mainAxisSize: MainAxisSize.max, children: <Widget>[ Expanded( child: ElevatedButton.icon( onPressed: widget.canEdit && widget.currentStage == widget.history.stageId ? requestCameraPermission : null, icon: Icon(Icons.add_a_photo, color: Colors.white), label: Text( AppString.get(context).add(), style: Theme.of(context) .textTheme .subtitle1 ?.copyWith(color: Colors.white), ), style: ElevatedButton.styleFrom( primary: appSecondaryColor, ), ), ), SizedBox( width: 5, height: 0, ), Expanded( child: ElevatedButton.icon( onPressed: imagesCount > 0 ? showAllPhotos : null, icon: Icon(Icons.list, color: Colors.white), label: Text( AppString.get(context).viewAll(), style: Theme.of(context) .textTheme .subtitle1 ?.copyWith(color: Colors.white), ), style: ElevatedButton.styleFrom( primary: appSecondaryColor, ), ), ), ], ), ),





 ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(_ImageSliderClass oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void addMorePhotos() async {
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

      BlocProvider.of<FileUploadBloc>(context).add(
        AddToUploadEvent(
          UploadModel(
            module: UploadModule.SCHEDULED_ACTIVITY,
            files: files,
            moduleId: widget.history.schedulerId,
            subTitle:
                '${widget.currentStage.toUpperCase()} - ${widget.activity.propertyNumber ?? widget.activity.propertyName}',
            moduleStatus: widget.currentStage,
          ),
        ),
      );

      Utils.showSnackMessage(context, '${files.length} Files added to Upload');
    }).catchError((error) {
      Utils.showSnackMessage(context, error.toString());
    });
  }
Future<void> requestCameraPermission() async { final status = await Permission.camera.request(); if (status.isPermanentlyDenied) { showDialog( context: context, builder: (BuildContext context) => AlertDialog( title: Text('Camera Permission Required'), content: Text('Camera permission is required to add photos. Please enable it in the app settings.'), actions: [ TextButton( child: Text('Cancel'), onPressed: () => Navigator.of(context).pop(), ), TextButton( child: Text('Open Settings'), onPressed: () { Navigator.of(context).pop(); openAppSettings(); }, ), ], ), ); } else if (status.isGranted) { addMorePhotos(); } else { requestCameraPermission(); } }




  void pickPhotos() async {
    Utils.showSnackMessage(context, 'Currently unavailable');
  }

  // Future<void> requestCameraPermission() async {
  //   final status = await Permission.camera.request();
  //   if (status.isGranted) {
  //     addMorePhotos();
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: Text('Camera Permission'),
  //         content: Text('Camera permission is required to add photos.'),
  //         actions: [
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  void showAllPhotos() {
    print('${widget.history.images![0]}');
    Navigator.pop(context);
    Navigator.pushNamed(context, RoutesName.imageSliderScreen,
        arguments: ImagesSliderList(
            imagesList: widget.history.images!,
            title: widget.history.images!.toString()));
  }
}
