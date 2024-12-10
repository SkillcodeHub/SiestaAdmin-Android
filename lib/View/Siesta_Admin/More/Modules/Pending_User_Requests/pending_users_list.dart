import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Data/Response/status.dart';
import 'package:siestaamsapp/Model/More_Model/getUsersList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/Utils/Widgets/errorScreen_widget.dart';
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/PendingUserRequests_View_Model/pending_user_request_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

import '../../../../../Provider/app_language_provider.dart';

class PendingUsersListPage extends StatefulWidget {
  const PendingUsersListPage({super.key});

  @override
  State<PendingUsersListPage> createState() => _PendingUsersListPageState();
}

class _PendingUsersListPageState extends State<PendingUsersListPage> {
  dynamic pageError;
  late List<User> listUsers;
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


    fetchDataFuture = fetchData(); // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final pendingUserRequestViewmodel =
          Provider.of<PendingUserRequestViewmodel>(context, listen: false);

      pendingUserRequestViewmodel.fetchPendingUserRequestApi(token.toString(),currentAppLanguage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingUserRequestViewmodel =
        Provider.of<PendingUserRequestViewmodel>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: appPrimaryColor,
          titleSpacing: 0,
          title: Text(
            AppString.get(context).newUserRequests(),
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
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pending_outlined, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      AppString.get(context).pending(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.block, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      AppString.get(context).blocked(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
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
              return ChangeNotifierProvider<PendingUserRequestViewmodel>.value(
                value: pendingUserRequestViewmodel,
                child: Consumer<PendingUserRequestViewmodel>(
                  builder: (context, value, _) {
                    switch (value.pendingUserRequestDetails.status!) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());

                      case Status.ERROR:
                        print(value.pendingUserRequestDetails.message);
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.pendingUserRequestDetails.message
                              .toString(),
                        );

                      case Status.COMPLETED:
                        listUsers = value.pendingUserRequestDetails.data!.data!;

                        return Container(
                          color: Colors.grey.shade200,
                          child: widgetUsersList(context),
                        );
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget widgetUsersList(BuildContext context) {
    return TabBarView(
      children: [
        widgetPendingUsersList(context),
        widgetBlockedUsersList(context),
      ],
    );
  }

  Widget widgetPendingUsersList(BuildContext context) {
    List<User> filtered =
        listUsers.where((element) => element.active! > 0).toList();
    return ListView.builder(
      itemCount: filtered.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return _userItem(context, filtered[index]);
      },
    );
  }

  Widget widgetBlockedUsersList(BuildContext context) {
    List<User> filtered =
        listUsers.where((element) => element.active! <= 0).toList();
    return ListView.builder(
      itemCount: filtered.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return _userItem(context, filtered[index]);
      },
    );
  }

  Widget _userItem(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.usersDetailPage,
            arguments: user);
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Flexible(
                child: Icon(
                  Icons.person_pin_rounded,
                  color: Colors.black,
                  size: 50,
                ),
              ),
              SizedBox(width: 8),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(flex: 1)
                },
                children: [
                  TableRow(children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      user.userFullname ?? "",
                      style: TextStyle(color: Colors.black),
                    )
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(user.userMobile!.truncate().toString())
                  ]),
                  TableRow(children: [
                    Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(user.userEmail ?? '')
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
