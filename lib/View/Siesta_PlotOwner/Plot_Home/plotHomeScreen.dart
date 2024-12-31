import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/View/Siesta_PlotOwner/Plot_Home/plotScheduledTaskAddNew_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart' as intl;
import '../../../Data/Response/status.dart';
import '../../../Model/PlotOwner_Model/plotOwnerScheduledActivites_model.dart';
import '../../../Provider/app_language_provider.dart';
import '../../../Res/colors.dart';
import '../../../Utils/Routes/routes_name.dart';
import '../../../Utils/Widgets/errorScreen_widget.dart';
import '../../../Utils/utils.dart';
import '../../../View_Model/Dashboard_View_Model/scheduled_activitiesById_view_model.dart';
import '../../../View_Model/PlotOwner_View_Model/plotOwnerScheduledActivities_view_model.dart';
import '../../../constants/modules.dart';
import '../../../constants/string_res.dart';
import '../../SharedPreferences/sharePreference.dart';
import '../../file_upload/file_upload_widget.dart';
import '../../main_admin_providers.dart';

class PlotHomeScreen extends StatefulWidget {
  const PlotHomeScreen({super.key});

  @override
  State<PlotHomeScreen> createState() => _PlotHomeScreenState();
}

class _PlotHomeScreenState extends State<PlotHomeScreen> {
  late Future<void> fetchDataFuture;

  num bNavIndex = 0;
  bool showFilterView = false;
  bool canViewReport = false,
      canAddSchedTask = false,
      canViewNotfRequests = false;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late TextEditingController _searchController;
  bool isSearchShows = false;
  List<PlotOwnerScheduledActivities> data = [];
  String? propertyNumber;
  String? schedulerId;
  List<PlotOwnerScheduledActivities> filteredData = [];
  TextEditingController searchController = TextEditingController();
  late AuthModal authModal;
  bool permissionGranted = false;
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

    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;

    canAddSchedTask = authModal.canAdd!.contains(moduleScheduledActivity);

    fetchDataFuture = fetchData();
    _searchController = TextEditingController();

    // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final plotOwnerScheduledActivitiesViewmodel =
          Provider.of<PlotOwnerScheduledActivitiesViewmodel>(context, listen: false);

      plotOwnerScheduledActivitiesViewmodel.fetchPlotOwnerScheduledActivitiessApi(
          token.toString(), currentAppLanguage);
    });
  }





  get() {
    Timer(Duration(microseconds: 20), () {
      final scheduledActivitiesByIdByIdViewmodel =
          Provider.of<ScheduledActivitiesByIdByIdViewmodel>(context,
              listen: false);

      scheduledActivitiesByIdByIdViewmodel.fetchScheduledActivitiesByIdApi(
          schedulerId.toString(), token.toString(), currentAppLanguage);
    });
  }

  List<PlotOwnerScheduledActivities> filterData(String searchString) {
    if (searchString.isEmpty) {
      return data;
    }

    return data.where((item) {
      String propertyNumber = item.propertyNumber.toString().toLowerCase();
      return propertyNumber.contains(searchString.toLowerCase());
    }).toList();
  }

  Widget createExpansionTiles(
      BuildContext context, List<PlotOwnerScheduledActivities> dataList) {
    // Group data by propertyNumber
    Map<String, List<PlotOwnerScheduledActivities>> groupedData = {};
    for (PlotOwnerScheduledActivities data in dataList) {
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
          status: activity.executionStatus.toString(),
          createdDate: activity.createdDateUTC.toString(),
          deadlineDate: activity.delayDeadline,
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

              // Timer(Duration(seconds: 2), () {
              // Navigator.pushNamed(context, RoutesName.scheduledTaskDetail,
              //     arguments: data1);
              // });
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
              initiallyExpanded: true, // Add this line

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
          children: activityTiles,
        ),
      );
    });

    return Column(children: expansionTiles);
  }

  @override
  Widget build(BuildContext context) {
    print('AccessToken${token}');

    final plotOwnerScheduledActivitiesViewmodel =
        Provider.of<PlotOwnerScheduledActivitiesViewmodel>(context);

    DateTime date = DateTime.now();
    String pDate = date.toUtc().toIso8601String();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Image(
            image: AssetImage('asset/images/logo_admin.png'),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  AppString.get(context).appHeadingAdmin(),
                  style:
                      TextStyle(fontSize: headerFontSize, color: Colors.white),
                ),
              ),
            ],
          ),
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
              return ChangeNotifierProvider<PlotOwnerScheduledActivitiesViewmodel>.value(
                value: plotOwnerScheduledActivitiesViewmodel,
                child: Consumer<PlotOwnerScheduledActivitiesViewmodel>(
                  builder: (context, value, _) {
                    switch (value.PlotOwnerScheduledActivitiesList.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        // print(
                        //     'value.scheduledActivitiesList.message.toString()');
                        // print(value.scheduledActivitiesList.message);
                        // return ErrorScreenWidget(
                        //   onRefresh: () async {
                        //     fetchData();
                        //   },
                        //   loadingText:
                        //       value.scheduledActivitiesList.message.toString(),
                        // );

                        if (value.PlotOwnerScheduledActivitiesList.message ==
                            "No Internet Connection") {
                          return ErrorScreenWidget(
                            onRefresh: () async {
                              fetchData();
                            },
                            loadingText: value.PlotOwnerScheduledActivitiesList.message
                                .toString(),
                          );
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => LoginScreen()),
                            //   (route) => false,
                            // );
                          });
                          return Container();
                        }
                      case Status.COMPLETED:
                        data = value.PlotOwnerScheduledActivitiesList.data!.data!;
                        if (!isSearchShows) {
                          filteredData =
                              value.PlotOwnerScheduledActivitiesList.data!.data!;
                        }

                        return isSearchShows
                            ? Container(
                                color: Colors.grey.shade200,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 8, bottom: 64),
                                        itemBuilder: (context, index) {
                                          return createExpansionTiles(
                                              context, filteredData);
                                        },
                                        itemCount: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        padding:
                                            EdgeInsets.only(top: 8, bottom: 64),
                                        itemBuilder: (context, index) {
                                          return createExpansionTiles(
                                              context,
                                              value.PlotOwnerScheduledActivitiesList
                                                  .data!.data!);
                                        },
                                        itemCount: 1,
                                      ),
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
        ),
       
       
        floatingActionButton: 
        
        // canAddSchedTask
        //     ?
            
             FloatingActionButton(
                backgroundColor: appSecondaryColor,
                mini: true,
                onPressed: () {
                  // Navigator.pushNamed(context, RoutesName.ScheduledTaskAddNew);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PlotScheduledTaskAddNewPage())) .then((value) {
                    // Rebuild this screen when navigating back from TwoScreen
                    if (value == true) {
                      fetchDataFuture = fetchData(); // Call the API only
                    }
                  });
                },
                child: Icon(Icons.add),
              )
            // : null,
      ),
    );
  }
}
