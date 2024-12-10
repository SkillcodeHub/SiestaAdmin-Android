import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Custom/custom_views.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/Custom_Model/selectable_day.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivity_schedulersList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/Siesta_Admin/More/Modules/Activity_Scheduler/activity_scheduler_details.dart';
import 'package:siestaamsapp/View/Siesta_Admin/Report/Regular_Report_Detail/expansion_entry.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/Dashboard_View_Model/AddTask_View_Model/getActivity_schedulersList_view_model.dart';
import 'package:siestaamsapp/constants/modules.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class ActivitySchedulerListPage extends StatefulWidget {
  const ActivitySchedulerListPage({super.key});

  @override
  State<ActivitySchedulerListPage> createState() =>
      _ActivitySchedulerListPageState();
}

class _ActivitySchedulerListPageState extends State<ActivitySchedulerListPage> {
  dynamic pageError;
  List<ExpansionEntry> _expandedItems = [];
  Map<String, List<ActivitySchedulers>> map = {};
  bool isSearchShows = false;
  List<ActivitySchedulers> filteredData = [];
  List<ActivitySchedulers> data = [];

  List<ActivitySchedulers>? _activeList, _backupList;
  bool showFilterView = false;
  late TextEditingController _searchController;
  UserPreferences userPreference = UserPreferences();
  dynamic UserData;
  String? token;
  late Future<void> fetchDataFuture;
  late AuthModal authModal;
  late bool canAdd;
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

    canAdd = authModal.canAdd!.contains(moduleActivityScheduler);

    _activeList = [];
    _backupList = [];
    _searchController = TextEditingController();
    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getActivitySchedulersListViewmodel =
          Provider.of<GetActivitySchedulersListViewmodel>(context,
              listen: false);

      getActivitySchedulersListViewmodel
          .fetchGetActivitySchedulersListApi(token.toString(),currentAppLanguage);
    });
  }

  List<ActivitySchedulers>? filterData(String searchString) {
    if (searchString.isEmpty) {
      return _backupList;
    }

    return _backupList!.where((item) {
      String propertyNumber = (item.propertyNumber ?? '').toLowerCase();
      String propertyName =
          (item.propertyNameTranslation ?? item.propertyName ?? '')
              .toLowerCase();
      String activityName =
          (item.activityNameTranslation ?? item.activityName ?? '')
              .toLowerCase();
      String searchStr = searchString.toLowerCase();
      return propertyNumber.contains(searchStr) ||
          propertyName.contains(searchStr) ||
          activityName.contains(searchStr);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getActivitySchedulersListViewmodel =
        Provider.of<GetActivitySchedulersListViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).activityScheduler(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchShows ? isSearchShows = false : isSearchShows = true;
                });
              },
              icon: Icon(
                Icons.search,
                color: isSearchShows ? appSecondaryColor : Colors.white,
              ),
              color: Colors.white),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _searchController.clear();
                fetchDataFuture = fetchData();
                isSearchShows = false;
              });
            },
          )
        ],
        bottom: isSearchShows
            ? PreferredSize(
                preferredSize: Size(double.maxFinite, 56),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            filteredData = filterData(value)!;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                          labelText:
                              '${AppString.get(context).activity()} ${AppString.get(context).name()}/${AppString.get(context).assets()} ${AppString.get(context).name()}',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
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
                GetActivitySchedulersListViewmodel>.value(
              value: getActivitySchedulersListViewmodel,
              child: Consumer<GetActivitySchedulersListViewmodel>(
                builder: (context, value, _) {
                  switch (value.getActivitySchedulersList.status!) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());

                    case Status.ERROR:
                      if (value.getActivitySchedulersList.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.getActivitySchedulersList.message
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
                      _backupList = value.getActivitySchedulersList.data!.data!;
                      _activeList!.clear();
                      _activeList!.addAll(_backupList!);

                      // Filter data based on search query
                      if (isSearchShows) {
                        filteredData = filterData(_searchController.text) ?? [];
                      } else {
                        filteredData = _backupList!;
                      }

                      _resetExpandedList(context, filteredData);

                      return Container(
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 64, top: 8),
                          itemCount: map.keys.length,
                          itemBuilder: (context, index) {
                            var tempList = map.keys.toList(growable: false);
                            tempList.sort((a, b) => a.compareTo(b));
                            String key = tempList.elementAt(index);
                            List<ActivitySchedulers> children = map[key]!;
                            List<ExpansionEntry> tempChildrenList = [];
                            children.forEach((value) {
                              tempChildrenList
                                  .add(ExpansionEntry(_TaskItem(value, token)));
                            });

                            return widgetItem(
                              context: context,
                              key: key,
                              children: children,
                              tempChildrenList: tempChildrenList,
                            );
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
      floatingActionButton: canAdd
          ? FloatingActionButton(
              backgroundColor: appSecondaryColor,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutesName.ActivitySchedulerAddNew,
                ).then((value) {
                  // Rebuild this screen when navigating back from TwoScreen
                  if (value == true) {
                    fetchDataFuture = fetchData(); // Call the API only
                  }
                });
              },
              elevation: 4,
              mini: true,
              tooltip: AppString.get(context).addNewScheduler(),
              child: Icon(Icons.add),
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }

  Widget widgetItem({
    BuildContext? context,
    String? key,
    List<ActivitySchedulers>? children,
    List<ExpansionEntry>? tempChildrenList,
  }) {
    return ExpandedItem(
      ExpansionEntry(
        Container(
          height: 92,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: Text(key!, style: TextStyle(fontSize: titleFontSize)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: Theme.of(context!).textTheme.subtitle2,
                            children: [
                              TextSpan(
                                text:
                                    '${tempChildrenList!.length} ${AppString.get(context).scheduler()}',
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      InkWell(
                        child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          elevation: 2,
                          backgroundColor: appSecondaryColor,
                          avatar: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            AppString.get(context).add(),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(
                            RoutesName.ActivitySchedulerAddNew,
                            arguments: children![0],
                          )
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ActivitySchedulerAddNewPage(
                              //               activity: children![0] != 'null'
                              //                   ? children[0]
                              //                   : null,
                              //             )))
                              .then((value) {
                            // Rebuild this screen when navigating back from TwoScreen
                            if (value == true) {
                              fetchDataFuture =
                                  fetchData(); // Call the API only
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        children: tempChildrenList,
      ),
    );
  }

  Widget widgetAppbar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Text(AppString.get(context).activityScheduler()),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            fetchDataFuture = fetchData();
          },
        )
      ],
    );
  }

  void _resetExpandedList(BuildContext context,
      [List<ActivitySchedulers>? list]) {
    _expandedItems.clear();
    map.clear();
    try {
      final dataToUse = isSearchShows ? filteredData : (list ?? _backupList);
      if (dataToUse != null) {
        dataToUse.forEach(
          (value) {
            String key = value.propertyNameTranslation?.toUpperCase() ??
                value.propertyName?.toUpperCase() ??
                value.propertyNumber!.toUpperCase();
            if (map.containsKey(key)) {
              List<ActivitySchedulers> list = map[key] ?? [];
              list.add(value);
              list.sort((a1, a2) {
                var cmp1 = a2.active!.compareTo(a1.active!);
                if (cmp1 != 0) return cmp1;
                if ((a1.activityNameTranslation ?? a1.activityName) == null &&
                    (a2.activityNameTranslation ?? a2.activityName) == null)
                  return 0;
                if ((a2.activityNameTranslation ?? a2.activityName) == null)
                  return 1;
                if ((a1.activityNameTranslation ?? a1.activityName) == null)
                  return -1;
                return (a1.activityNameTranslation ?? a1.activityName)!
                    .compareTo(
                        (a2.activityNameTranslation ?? a2.activityName!));
              });
              map[key] = list;
            } else {
              List<ActivitySchedulers> list = [value];
              list.sort((a1, a2) {
                var cmp1 = a2.active!.compareTo(a1.active!);
                if (cmp1 != 0) return cmp1;
                if ((a1.activityNameTranslation ?? a1.activityName) == null &&
                    (a2.activityNameTranslation ?? a2.activityName) == null)
                  return 0;
                if ((a2.activityNameTranslation ?? a2.activityName) == null)
                  return 1;
                if ((a1.activityNameTranslation ?? a1.activityName) == null)
                  return -1;
                return (a1.activityNameTranslation ?? a1.activityName)!
                    .compareTo(a2.activityNameTranslation ?? a2.activityName!);
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
    } catch (e) {
      print('error in generate list');
      print(e);
    }
  }
}

class _TaskItem extends StatefulWidget {
  final ActivitySchedulers activity;
  dynamic token;

  _TaskItem(this.activity, this.token, {Key? key}) : super(key: key);

  @override
  State<_TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<_TaskItem> {
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

    // fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getActivitySchedulersListViewmodel =
          Provider.of<GetActivitySchedulersListViewmodel>(context,
              listen: false);

      getActivitySchedulersListViewmodel
          .fetchGetActivitySchedulersListApi(widget.token.toString(),currentAppLanguage);
    });
  }

  void _openSchedulerItemDetail(
      BuildContext context, ActivitySchedulers activity) {
    Map data = {
      'token': widget.token.toString(),
      'schedulerId': activity.schedulerId,
      'activityName': activity.activityName,
    };
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActivitySchedulerDetailPage(
                  activity: data,
                ))).then((value) {
      // Rebuild this screen when navigating back from TwoScreen
      if (value == true) {
        fetchDataFuture = fetchData(); // Call the API only
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSchedulerItemDetail(context, widget.activity),
      child: Card(
        color:
            widget.activity.active == 1 ? Colors.white : Colors.grey.shade400,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.activity.activityNameTranslation ??
                              widget.activity.activityName ??
                              "-",
                          maxLines: 1,
                          softWrap: true,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: (widget.activity.active == 1 &&
                                widget.activity.isAutoSchedulable == 1)
                            ? appSecondaryColor
                            : Theme.of(context).disabledColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                        child: Text(
                          widget.activity.autoSchedulableText ?? "-",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.subtitle2,
                            children: [
                              TextSpan(
                                text: AppString.get(context).schedule() + ': ',
                              ),
                              TextSpan(
                                text: widget.activity.everyDaySpan == null
                                    ? '${AppString.get(context).every()} ${widget.activity.scheduleIntervalValue} ${widget.activity.scheduleIntervalUnit} - '
                                        '${widget.activity.frequencyQty} ${AppString.get(context).times()}'
                                    : '${AppString.get(context).every()} ${widget.activity.everyDaySpanText}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (widget.activity.everyDaySpan == null)
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.subtitle2,
                              children: [
                                TextSpan(
                                  text: AppString.get(context).date() + ': ',
                                ),
                                TextSpan(
                                  text:
                                      '${DateFormat('d MMM yyyy').format(DateTime.parse(widget.activity.scheduledDate.toString()).toLocal())}',
                                )
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.subtitle2,
                              children: [
                                TextSpan(
                                  text: AppString.get(context).lastInterval() +
                                      ': ',
                                ),
                                TextSpan(
                                  text: widget.activity.lastRunDate == null
                                      ? '-'
                                      : '${DateFormat('d MMM yyyy').format(DateTime.parse(widget.activity.lastRunDate.toString()).toLocal())}',
                                )
                              ],
                            ),
                          ),
                        ]),
                  if (widget.activity.everyDaySpan != null &&
                      widget.activity.everyDaySpan == 'day')
                    Container(
                      height: 0,
                    ),
                  if (widget.activity.everyDaySpan != null &&
                      widget.activity.everyDaySpan == 'week')
                    WeekDaysView(
                        enabledEntries: widget.activity.everyDaySpanValue),
                  if (widget.activity.everyDaySpan != null &&
                      widget.activity.everyDaySpan == 'month')
                    MonthDaysView(
                        enabledEntries: widget.activity.everyDaySpanValue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeekDaysView extends StatelessWidget {
  final List<num>? enabledEntries;
  final ValueChanged<SelectableDay>? onDayClicked;
  final bool? isClickable;

  WeekDaysView({
    Key? key,
    this.enabledEntries,
    this.onDayClicked,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getDayWidget(context, AppString.get(context).mo(),
            enabledEntries != null && enabledEntries!.contains(0), 0),
        getDayWidget(context, AppString.get(context).tu(),
            enabledEntries != null && enabledEntries!.contains(1), 1),
        getDayWidget(context, AppString.get(context).we(),
            enabledEntries != null && enabledEntries!.contains(2), 2),
        getDayWidget(context, AppString.get(context).th(),
            enabledEntries != null && enabledEntries!.contains(3), 3),
        getDayWidget(context, AppString.get(context).fr(),
            enabledEntries != null && enabledEntries!.contains(4), 4),
        getDayWidget(context, AppString.get(context).sa(),
            enabledEntries != null && enabledEntries!.contains(5), 5),
        getDayWidget(context, AppString.get(context).su(),
            enabledEntries != null && enabledEntries!.contains(6), 6),
      ],
    );
  }

  Widget getDayWidget(
    BuildContext context,
    String name,
    bool enabled,
    num dayValue, {
    num? fontSize,
    FontWeight? fontWeight,
    Color? fontColor,
    Color? backgroundColor,
    num? containerHeight,
    num? flex,
  }) {
    return Expanded(
      flex: flex?.toInt() ?? 1,
      child: InkWell(
        onTap: isClickable!
            ? () {
                onDayClicked!(SelectableDay(
                    name: name, isSelected: enabled, dayValue: dayValue));
              }
            : null,
        child: Container(
          height: containerHeight?.toDouble() ?? 30,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? backgroundColor ?? appSecondaryColor
                : Theme.of(context).disabledColor,
          ),
          child: Text(
            name,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: fontColor ?? Colors.white,
                  fontSize: fontSize?.toDouble() ?? 12,
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
