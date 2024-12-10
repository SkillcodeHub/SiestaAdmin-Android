import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/More_Model/activityExecution_stages_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/Auth/Authentication/LoginPage/login_screen.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View/main_admin_providers.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activity_Execution_Stages_List_View_Model/activity_execution_stages_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class ActivityExecutionStagesListPage extends StatefulWidget {
  const ActivityExecutionStagesListPage({super.key});

  @override
  State<ActivityExecutionStagesListPage> createState() =>
      _ActivityExecutionStagesListPageState();
}

class _ActivityExecutionStagesListPageState
    extends State<ActivityExecutionStagesListPage> {
  late bool canAdd;
  late AuthModal authModal;

  late List<ActivityExecutionStage> list;
  dynamic pageError;
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


    fetchDataFuture = fetchData(); // Call the API only once

    list = [];
    authModal =
        Provider.of<AuthStateProvider>(context, listen: false).checkLoginState;
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final activityExecutionStagesListViewmodel =
          Provider.of<ActivityExecutionStagesListViewmodel>(context,
              listen: false);
      activityExecutionStagesListViewmodel
          .fetchGetActivityDetailsApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityExecutionStagesListViewmodel =
        Provider.of<ActivityExecutionStagesListViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).activityStages(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              fetchDataFuture = fetchData();
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
            return ChangeNotifierProvider<
                ActivityExecutionStagesListViewmodel>.value(
              value: activityExecutionStagesListViewmodel,
              child: Consumer<ActivityExecutionStagesListViewmodel>(
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
                          loadingText: value.activityExecutionStagesList.message
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
                      List<ActivityExecutionStage> list =
                          value.activityExecutionStagesList.data!.data!;
                      this.list = list;
                      return Container(
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          itemCount: list.length,
                          padding: EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return _taskItem(context, item);
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

  Widget _taskItem(BuildContext context, ActivityExecutionStage activity) {
    return GestureDetector(
      onTap: () => _openItemDetail(context, activity),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: IntrinsicColumnWidth(flex: 1),
            },
            children: [
              TableRow(children: [
                Text(
                  '${AppString.get(context).stageName()}: ${activity.stageNameTranslation ?? activity.stageName ?? ""}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                ),
                Container(),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                Container(),
              ]),
              TableRow(
                children: [
                  Text(
                    '${AppString.get(context).stageCode()}: ${activity.stageCode ?? ""}',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: descriptionFontSize),
                  ),
                  Container(),
                ],
              ),
              TableRow(children: [
                SizedBox(
                  height: 5,
                ),
                Container(),
              ]),
              TableRow(
                children: [
                  Text(
                    '${AppString.get(context).autoRemovableByScheduler()} : ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: descriptionFontSize),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      activity.autoRemoveByScheduler! > 0
                          ? Icons.done
                          : Icons.close,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openItemDetail(BuildContext context, ActivityExecutionStage activity) {
    Navigator.pushNamed(context, RoutesName.activityExecutionStageDetailsPage,
        arguments: activity);
  }
}
