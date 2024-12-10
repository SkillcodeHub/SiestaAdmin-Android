// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:siestaamsapp/Data/Response/status.dart';
// import 'package:siestaamsapp/Model/Report_Model/activity_groups.dart';
// import 'package:siestaamsapp/Model/Report_Model/priorityTask.dart';
// import 'package:siestaamsapp/Model/Report_Model/taskStage_Model.dart';
// import 'package:siestaamsapp/Model/Report_Model/task_stage_report_overview.dart';
// import 'package:siestaamsapp/Res/colors.dart';
// import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
// import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
// import 'package:siestaamsapp/Utils/utils.dart';
// import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
// import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
// import 'package:siestaamsapp/View/Siesta_Admin/Report/Priority_Report_Detail/priority_task_stage_detail_report.dart';
// import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/task_stage_detail_report_widget.dart';
// import 'package:siestaamsapp/View_Model/Report_View_Model/activityGroups_view_model.dart';
// import 'package:siestaamsapp/View_Model/Report_View_Model/priorityTask_view_model.dart';
// import 'package:siestaamsapp/View_Model/Report_View_Model/taskStage_view_model.dart';
// import 'package:siestaamsapp/constants/string_res.dart';
// import 'package:sizer/sizer.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   UserPreferences userPreference = UserPreferences();
//   dynamic UserData;
//   String? token;
//   late Future<void> fetchDataFuture;
//   late ActivityGroups group = ActivityGroups();
//   late List<ActivityGroups> groups;
//   late List<TaskStageReportOverview> list;
//   late String priority = '1';
//   late String electedName = ' ';
//   late String electedCode = ' ';
//   // late PriorityTask stageCode;
//   @override
//   void initState() {
//     userPreference.getUserData().then((value) {
//       setState(() {
//         UserData = value!;
//         token = UserData['data']['accessToken'].toString();
//         // cmsToken = UserData['data']['cmsToken'].toString();
//         // print('CMS Token : $cmsToken');
//       });
//     });

//     super.initState();
//     fetchDataFuture = fetchData(); // Call the API only once
//   }

//   Future<void> fetchData() async {
//     Timer(Duration(microseconds: 20), () {
//       final taskStageViewmodel =
//           Provider.of<TaskStageViewmodel>(context, listen: false);

//       taskStageViewmodel.fetchTaskStageApi(token.toString());

//       final activityGroupsViewmodel =
//           Provider.of<ActivityGroupsViewmodel>(context, listen: false);
//       activityGroupsViewmodel.fetchActivityGroupsApi(token.toString());
//     });
//   }

//   get() {
//     final priorityTaskViewmodel =
//         Provider.of<PriorityTaskViewmodel>(context, listen: false);
//     priorityTaskViewmodel.fetchPriorityTaskApi(electedCode, token.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskStageViewmodel =
//         Provider.of<TaskStageViewmodel>(context, listen: false);
//     final activityGroupsViewmodel =
//         Provider.of<ActivityGroupsViewmodel>(context, listen: false);
//     final priorityTaskViewmodel =
//         Provider.of<PriorityTaskViewmodel>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: Image(
//           image: AssetImage('asset/images/logo_admin.png'),
//         ),
//         title: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//               child: Text(
//                 AppString.get(context).appHeadingAdmin(),
//                 style: Theme.of(context)
//                     .textTheme
//                     .headline6
//                     ?.copyWith(color: Colors.white),
//               ),
//             ),
//             /*Container(
//                 child: Text(
//                   'subtitle',
//                   style: Theme.of(context)
//                       .textTheme
//                       .subtitle1
//                       .copyWith(color: Colors.white, fontFamily: 'Raleway'),
//                 ),
//               ),*/
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                   onPressed: () {
//                     fetchDataFuture = fetchData();
//                   },
//                   icon: Icon(Icons.refresh),
//                   color: Colors.white),
//               PopupMenuButton<int>(
//                 itemBuilder: (context) => [
//                   // popupmenu item 1
//                   PopupMenuItem(
//                     onTap: () {
//                       Timer(Duration(microseconds: 20), () {
//                         Navigator.pushNamed(
//                             context, RoutesName.fileUploadScreen);
//                       });
//                     },
//                     // value: 1,
//                     // row has two child icon and text.
//                     child: Row(
//                       children: [
//                         Icon(Icons.star),
//                         SizedBox(
//                           // sized box with width 10
//                           width: 10,
//                         ),
//                         Text("Uploads")
//                       ],
//                     ),
//                   ),
//                   // popupmenu item 2
//                   PopupMenuItem(
//                     onTap: () {
//                       Timer(Duration(microseconds: 20), () {
//                         Navigator.pushNamed(context, RoutesName.profileScreen);
//                       });
//                     },
//                     // value: 2,
//                     // row has two child icon and text
//                     child: Row(
//                       children: [
//                         Icon(Icons.chrome_reader_mode),
//                         SizedBox(
//                           // sized box with width 10
//                           width: 10,
//                         ),
//                         Text("Profile")
//                       ],
//                     ),
//                   ),

//                   PopupMenuItem(
//                     onTap: () {
//                       Timer(Duration(microseconds: 20), () {
//                         Navigator.pushNamed(context, RoutesName.settingScreen);
//                       });
//                     },
//                     // value: 3,
//                     // row has two child icon and text
//                     child: Row(
//                       children: [
//                         Icon(Icons.chrome_reader_mode),
//                         SizedBox(
//                           // sized box with width 10
//                           width: 10,
//                         ),
//                         Text("Settings")
//                       ],
//                     ),
//                   ),

//                   PopupMenuItem(
//                     onTap: () {
//                       Timer(Duration(microseconds: 20), () {
//                         showDialog(
//                           barrierDismissible: false,
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: Center(
//                                 child: Text(
//                                   'Logout',
//                                   style: TextStyle(
//                                     fontSize: titleFontSize,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               content: Text(
//                                 'Are you sure you want to logout?',
//                                 style: TextStyle(fontSize: descriptionFontSize),
//                                 textAlign: TextAlign.center,
//                               ),
//                               actions: <Widget>[
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           color: appPrimaryColor,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ),
//                                         width: 25.w,
//                                         child: Center(
//                                           child: Text(
//                                             'No',
//                                             style: TextStyle(
//                                               fontSize: titleFontSize,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 15.w),
//                                     InkWell(
//                                       onTap: () {
//                                         userPreference.logoutProcess();
//                                         Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => LoginScreen(),
//                                           ),
//                                           (route) => false,
//                                         );
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           color: appPrimaryColor,
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ),
//                                         width: 25.w,
//                                         child: Center(
//                                           child: Text(
//                                             'Yes',
//                                             style: TextStyle(
//                                               fontSize: titleFontSize,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       });
//                     },
//                     // value: 4,
//                     // row has two child icon and text
//                     child: Row(
//                       children: [
//                         Icon(Icons.chrome_reader_mode),
//                         SizedBox(
//                           // sized box with width 10
//                           width: 10,
//                         ),
//                         Text("Logout")
//                       ],
//                     ),
//                   ),
//                 ],
//                 offset: Offset(0, 40),
//                 color: Colors.white,
//                 elevation: 2,
//               ),
//             ],
//           )
//         ],
//       ),
//       body: FutureBuilder<void>(
//         future: fetchDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child:
//                   //  WaveLoaderWidget(),
//                   CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error occurred: ${snapshot.error}'),
//             );
//           } else {
//             // Render the UI with the fetched data
//             return ChangeNotifierProvider<TaskStageViewmodel>.value(
//               value: taskStageViewmodel,
//               child: Consumer<TaskStageViewmodel>(
//                 builder: (context, value, _) {
//                   switch (value.taskStageList.status!) {
//                     case Status.LOADING:
//                       return Center(
//                           child:
//                               //  WaveLoaderWidget()
//                               CircularProgressIndicator());

//                     case Status.ERROR:
//                       return ErrorScreenWidget(
//                         onRefresh: () async {
//                           fetchData();
//                         },
//                         loadingText: value.taskStageList.message.toString(),
//                       );
//                     case Status.COMPLETED:
//                       return LayoutBuilder(
//                         builder: (context, constraint) {
//                           return Container(
//                             height: constraint.maxHeight,
//                             width: constraint.maxWidth,
//                             color: Colors.grey.shade200,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.all(8),
//                                     child: Card(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               child: Text(
//                                                 '${AppString.get(context).activities()} ${AppString.get(context).status()}',
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .headline6,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 12,
//                                             ),
//                                             for (var i = 0,
//                                                     j = value.taskStageList
//                                                         .data!.data!.length;
//                                                 i < j;
//                                                 i++)
//                                               Column(
//                                                 children: [
//                                                   InkWell(
//                                                     onTap: value
//                                                                 .taskStageList
//                                                                 .data!
//                                                                 .data![i]
//                                                                 .totalCount!
//                                                                 .toInt() >
//                                                             0
//                                                         ? () => openTaskStageReportDetailPage(
//                                                             value.taskStageList
//                                                                 .data!.data![i],
//                                                             value.taskStageList
//                                                                 .data!.data!)
//                                                         : null,
//                                                     child: Container(
//                                                       padding:
//                                                           EdgeInsets.all(8),
//                                                       child: Row(
//                                                         children: [
//                                                           Expanded(
//                                                             child: Text(
//                                                               value
//                                                                   .taskStageList
//                                                                   .data!
//                                                                   .data![i]
//                                                                   .executionStageName
//                                                                   .toString(),
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .subtitle1
//                                                                   ?.copyWith(
//                                                                       fontSize:
//                                                                           18),
//                                                             ),
//                                                             flex: 1,
//                                                           ),
//                                                           Text(
//                                                             value
//                                                                 .taskStageList
//                                                                 .data!
//                                                                 .data![i]
//                                                                 .totalCount
//                                                                 .toString(),
//                                                             // 'sssssssssss',
//                                                             // '${list[i].totalCount}',
//                                                             style: Theme.of(
//                                                                     context)
//                                                                 .textTheme
//                                                                 .subtitle1,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 8,
//                                                           ),
//                                                           Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                               color: value
//                                                                           .taskStageList
//                                                                           .data!
//                                                                           .data![
//                                                                               i]
//                                                                           .totalCount!
//                                                                           .toInt() >
//                                                                       0
//                                                                   ? appSecondaryColor
//                                                                   : Theme.of(
//                                                                           context)
//                                                                       .disabledColor,
//                                                             ),
//                                                             child: Icon(
//                                                               Icons
//                                                                   .chevron_right,
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   if (i < j - 1)
//                                                     Divider(
//                                                       color: Colors.grey,
//                                                     )
//                                                 ],
//                                               )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   // _NotifiedTasksReportCard(),

//                                   ChangeNotifierProvider<
//                                       ActivityGroupsViewmodel>.value(
//                                     value: activityGroupsViewmodel,
//                                     child: Consumer<ActivityGroupsViewmodel>(
//                                       builder: (context, value, _) {
//                                         switch (
//                                             value.activityGroupsList.status!) {
//                                           case Status.LOADING:
//                                             return Center(
//                                                 child:
//                                                     //  WaveLoaderWidget()
//                                                     CircularProgressIndicator());

//                                           case Status.ERROR:
//                                             return ErrorScreenWidget(
//                                               onRefresh: () async {
//                                                 fetchData();
//                                               },
//                                               loadingText: value
//                                                   .activityGroupsList.message
//                                                   .toString(),
//                                             );
//                                           case Status.COMPLETED:
//                                             // Call the API with the default value when the DropdownButton is rendered
//                                             // if (priority.isNotEmpty &&
//                                             //     electedCode.isEmpty &&
//                                             //     electedName.isEmpty) {
//                                             //   electedName = value
//                                             //       .activityGroupsList
//                                             //       .data!
//                                             //       .data!
//                                             //       .firstWhere(
//                                             //         (doctor) =>
//                                             //             doctor.priority
//                                             //                 .toString() ==
//                                             //             priority,
//                                             //       )
//                                             //       .name
//                                             //       .toString();
//                                             //   electedCode = value
//                                             //       .activityGroupsList
//                                             //       .data!
//                                             //       .data!
//                                             //       .firstWhere(
//                                             //         (doctor) =>
//                                             //             doctor.priority
//                                             //                 .toString() ==
//                                             //             priority,
//                                             //       )
//                                             //       .code
//                                             //       .toString();
//                                             //   group = value.activityGroupsList
//                                             //       .data!.data!
//                                             //       .firstWhere(
//                                             //     (doctor) =>
//                                             //         doctor.priority
//                                             //             .toString() ==
//                                             //         priority,
//                                             //   );

//                                             //   // doctorNameProvider
//                                             //   //     .updateTextValues(
//                                             //   //   '${electedName}',
//                                             //   //   '${priority}',
//                                             //   // );

//                                             //   if (kDebugMode) {
//                                             //     print(
//                                             //         'updateTextValues :${electedCode}');
//                                             //     print(
//                                             //         'electedName ${electedName}');
//                                             //     print(
//                                             //         'selectedDoctorID ${priority}');
//                                             //   }

//                                             //   // Provider.of<
//                                             //   //     PriorityTaskViewmodel>(
//                                             //   //   context,
//                                             //   //   listen: false,
//                                             //   // );
//                                             //   priorityTaskViewmodel
//                                             //       .fetchPriorityTaskApi(
//                                             //     electedCode,
//                                             //     token.toString(),
//                                             //   );
//                                             // }

//                                             // priority = value
//                                             //     .activityGroupsList.data!.data![0].priority
//                                             //     .toString();
//                                             // priorityTaskViewmodel
//                                             //     .fetchPriorityTaskApi(
//                                             //         value.activityGroupsList
//                                             //             .data!.data![0].code
//                                             //             .toString(),
//                                             //         token.toString());

//                                             electedCode = value
//                                                 .activityGroupsList
//                                                 .data!
//                                                 .data![0]
//                                                 .code
//                                                 .toString();
//                                             group = value.activityGroupsList
//                                                 .data!.data![0];
//                                             Future.delayed(Duration.zero,
//                                                 () async {
//                                               get();
//                                             });
//                                             return Container(
//                                               padding: EdgeInsets.all(8),
//                                               child: Card(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Container(
//                                                         child: Text(
//                                                           '${AppString.get(context).priorityActivity()} ${AppString.get(context).status()}',
//                                                           style:
//                                                               Theme.of(context)
//                                                                   .textTheme
//                                                                   .headline6,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 12,
//                                                       ),
//                                                       if (value
//                                                               .activityGroupsList
//                                                               .data!
//                                                               .data!
//                                                               .length >
//                                                           1)
//                                                         Consumer<
//                                                                 DoctorNameProvider>(
//                                                             builder: (context,
//                                                                 doctorNameProvider,
//                                                                 _) {
//                                                           return Container(
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                                     horizontal:
//                                                                         8),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               border:
//                                                                   Border.all(
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .primaryColor,
//                                                                 style:
//                                                                     BorderStyle
//                                                                         .solid,
//                                                               ),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           5),
//                                                             ),
//                                                             child:
//                                                                 DropdownButtonHideUnderline(
//                                                               child:
//                                                                   ButtonTheme(
//                                                                 alignedDropdown:
//                                                                     true,
//                                                                 child:
//                                                                     DropdownButton<
//                                                                         String>(
//                                                                   isDense: true,
//                                                                   value:
//                                                                       priority,
//                                                                   onChanged:
//                                                                       (String?
//                                                                           newValue) {
//                                                                     priority =
//                                                                         newValue!;
//                                                                     electedName = value
//                                                                         .activityGroupsList
//                                                                         .data!
//                                                                         .data!
//                                                                         .firstWhere(
//                                                                           (doctor) =>
//                                                                               doctor.priority.toString() ==
//                                                                               newValue,
//                                                                         )
//                                                                         .name
//                                                                         .toString();
//                                                                     electedCode = value
//                                                                         .activityGroupsList
//                                                                         .data!
//                                                                         .data!
//                                                                         .firstWhere(
//                                                                           (doctor) =>
//                                                                               doctor.priority.toString() ==
//                                                                               newValue,
//                                                                         )
//                                                                         .code
//                                                                         .toString();
//                                                                     // group = value
//                                                                     //     .activityGroupsList
//                                                                     //     .data!
//                                                                     //     .data!;
//                                                                     group = value
//                                                                         .activityGroupsList
//                                                                         .data!
//                                                                         .data!
//                                                                         .firstWhere(
//                                                                       (doctor) =>
//                                                                           doctor
//                                                                               .priority
//                                                                               .toString() ==
//                                                                           newValue,
//                                                                     );

//                                                                     doctorNameProvider
//                                                                         .resetData();

//                                                                     doctorNameProvider
//                                                                         .updateTextValues(
//                                                                       '${electedName}',
//                                                                       '${priority}',
//                                                                     );
//                                                                     if (kDebugMode) {
//                                                                       print(
//                                                                           'updateTextValues :${electedCode}');
//                                                                       print(
//                                                                           'electedName ${electedName}');
//                                                                       print(
//                                                                           'selectedDoctorID ${priority}');
//                                                                     }

//                                                                     get();
//                                                                   },
//                                                                   items: value
//                                                                       .activityGroupsList
//                                                                       .data!
//                                                                       .data!
//                                                                       .map(
//                                                                           (map) {
//                                                                     return new DropdownMenuItem<
//                                                                         String>(
//                                                                       value: map
//                                                                           .priority
//                                                                           .toString(),
//                                                                       child:
//                                                                           Row(
//                                                                         mainAxisAlignment:
//                                                                             MainAxisAlignment.start,
//                                                                         children: <
//                                                                             Widget>[
//                                                                           Container(
//                                                                               child: Text(
//                                                                             map.name.toString(),
//                                                                             style:
//                                                                                 TextStyle(fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 6.sp, fontWeight: FontWeight.w500),
//                                                                             textAlign:
//                                                                                 TextAlign.start,
//                                                                           )),
//                                                                         ],
//                                                                       ),
//                                                                     );
//                                                                   }).toList(),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }),
//                                                       SizedBox(height: 2.h),
//                                                       ChangeNotifierProvider<
//                                                           PriorityTaskViewmodel>.value(
//                                                         value:
//                                                             priorityTaskViewmodel,
//                                                         child: Consumer<
//                                                             PriorityTaskViewmodel>(
//                                                           builder: (context,
//                                                               value, _) {
//                                                             switch (value
//                                                                 .priorityTaskList
//                                                                 .status!) {
//                                                               case Status
//                                                                   .LOADING:
//                                                                 return Center(
//                                                                     child:
//                                                                         //  WaveLoaderWidget()
//                                                                         CircularProgressIndicator());

//                                                               case Status.ERROR:
//                                                                 return ErrorScreenWidget(
//                                                                   onRefresh:
//                                                                       () async {
//                                                                     fetchData();
//                                                                   },
//                                                                   loadingText: value
//                                                                       .priorityTaskList
//                                                                       .message
//                                                                       .toString(),
//                                                                 );
//                                                               case Status
//                                                                   .COMPLETED:
//                                                                 print(
//                                                                     'priority');
//                                                                 print(priority);
//                                                                 print(
//                                                                     group.code);
//                                                                 print(
//                                                                     'priority');
//                                                                 return Column(
//                                                                   children: [
//                                                                     for (var i =
//                                                                                 0,
//                                                                             j = value.priorityTaskList.data!.data!.length;
//                                                                         i < j;
//                                                                         i++)
//                                                                       Column(
//                                                                         children: [
//                                                                           InkWell(
//                                                                             onTap: value.priorityTaskList.data!.data![i].totalCount!.toInt() > 0
//                                                                                 ? () => openActivitiesGroupsTaskReportDetailPage(value.priorityTaskList.data!.data![i], value.priorityTaskList.data!.data!, group)
//                                                                                 : null,
//                                                                             child:
//                                                                                 Container(
//                                                                               padding: EdgeInsets.all(8),
//                                                                               child: Row(
//                                                                                 children: [
//                                                                                   Expanded(
//                                                                                     child: Text(
//                                                                                       value.priorityTaskList.data!.data![i].executionStageName.toString(),
//                                                                                       // '${list[i].translation != null ? ActivityTranslation.fromJson(list[i].translation[_currentAppLang]).title : list[i].executionStageName}'
//                                                                                       // 'aaaaaaaaa',
//                                                                                       style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
//                                                                                     ),
//                                                                                     flex: 1,
//                                                                                   ),
//                                                                                   Text(
//                                                                                     value.priorityTaskList.data!.data![i].totalCount.toString(),
//                                                                                     // 'sssssssssss',
//                                                                                     // '${list[i].totalCount}',
//                                                                                     style: Theme.of(context).textTheme.subtitle1,
//                                                                                   ),
//                                                                                   SizedBox(
//                                                                                     width: 8,
//                                                                                   ),
//                                                                                   Container(
//                                                                                     decoration: BoxDecoration(
//                                                                                       shape: BoxShape.circle,
//                                                                                       color: value.priorityTaskList.data!.data![i].totalCount!.toInt() > 0 ? appSecondaryColor : Theme.of(context).disabledColor,
//                                                                                     ),
//                                                                                     child: Icon(
//                                                                                       Icons.chevron_right,
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                   )
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           if (i <
//                                                                               j - 1)
//                                                                             Divider(
//                                                                               color: Colors.grey,
//                                                                             )
//                                                                         ],
//                                                                       ),
//                                                                   ],
//                                                                 );
//                                                             }
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                   }
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   void openTaskStageReportDetailPage(Data stage, List<Data> list) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => TaskStageDetailReportPage(
//                   data: {'stage': stage, 'stageList': list},
//                 )));
//   }

//   void openActivitiesGroupsTaskReportDetailPage(
//     PriorityTask stage,
//     List<PriorityTask> list,
//     ActivityGroups activityGroup,
//   ) {
//     print('objectobjectobjectobjectobjectobjectobject');
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => PriorityTaskStageDetailReportPage(
//                   data: {
//                     'stage': stage,
//                     'stageList': list,
//                     'activityGroup': activityGroup,
//                   },
//                 )));
//   }
// }
