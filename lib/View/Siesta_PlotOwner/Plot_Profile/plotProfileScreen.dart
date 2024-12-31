import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Utils/utils.dart';

import '../../../Data/Response/status.dart';
import '../../../Model/More_Model/getUsersList_model.dart';
import '../../../Provider/app_language_provider.dart';
import '../../../Utils/Widgets/errorScreen_widget.dart';
import '../../../View_Model/PlotOwner_View_Model/getPlotOwnerProfile_view_model.dart';
import '../../../View_Model/PlotOwner_View_Model/updateProfileDetails_view_model.dart';
import '../../../constants/string_res.dart';
import '../../Auth/Authentication/LoginPage/login_screen.dart';
import '../../SharedPreferences/sharePreference.dart';

// class PlotProfileScreen extends StatefulWidget {
//   const PlotProfileScreen({super.key});

//   @override
//   State<PlotProfileScreen> createState() => _PlotProfileScreenState();
// }

// class _PlotProfileScreenState extends State<PlotProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

class DashboardProfile extends StatefulWidget {
  DashboardProfile({Key? key}) : super(key: key);

  @override
  DashboardProfileState createState() {
    return DashboardProfileState();
  }
}

class DashboardProfileState extends State<DashboardProfile> {
  // Utils.PageStatus pageStatus = Utils.PageStatus.IDLE;
  dynamic pageError;
  User? oldUser, newUser;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // NetworkApi networkApi;
  late String currentAppLanguage;
  dynamic UserData;
  String? token;
  UserPreferences userPreference = UserPreferences();
  late Future<void> fetchDataFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   // networkApi = Provider.of<NetworkApi>(context, listen: false);
  //   emailCtrl = TextEditingController();
  //   nameCtrl = TextEditingController();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     reloadProfile();
  //   });
  // }
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

    fetchDataFuture = fetchData();

    // Call the API only once
  }

  Future<void> fetchData() async {
    Timer(Duration(microseconds: 20), () {
      final getPlotOwnerProfileViewmodel =
          Provider.of<GetPlotOwnerProfileViewmodel>(context, listen: false);
      getPlotOwnerProfileViewmodel.fetchGetPlotOwnerProfileDetailsApi(
          token.toString(), currentAppLanguage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPlotOwnerProfileViewmodel =
        Provider.of<GetPlotOwnerProfileViewmodel>(context, listen: false);
    final updateProfileDetailsViewModel =
        Provider.of<UpdateProfileDetailsViewModel>(context, listen: false);

    return Scaffold(
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
            return ChangeNotifierProvider<GetPlotOwnerProfileViewmodel>.value(
              value: getPlotOwnerProfileViewmodel,
              child: Consumer<GetPlotOwnerProfileViewmodel>(
                builder: (context, value, _) {
                  switch (value.getPlotOwnerProfileDetails.status!) {
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

                      if (value.getPlotOwnerProfileDetails.message ==
                          "No Internet Connection") {
                        return ErrorScreenWidget(
                          onRefresh: () async {
                            fetchData();
                          },
                          loadingText: value.getPlotOwnerProfileDetails.message
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
                    if(value
                          .getPlotOwnerProfileDetails.data!.data!.userEmail.toString() != 'null' || value
                          .getPlotOwnerProfileDetails.data!.data!.userEmail != null){

                            emailCtrl.text = value
                          .getPlotOwnerProfileDetails.data!.data!.userEmail
                          .toString();

                          }
                      

                      nameCtrl.text = value
                          .getPlotOwnerProfileDetails.data!.data!.userFullname
                          .toString();

                      return Container(
                        height: double.maxFinite,
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              AppString.get(context).profile(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                            //   onPressed: () {
                                                Map data = {
                                                  "email": emailCtrl.text,
                                                  "fullName": nameCtrl.text,
                                                };

                                                updateProfileDetailsViewModel
                                                    .updateProfileDetailsApi(
                                                        token.toString(),
                                                        data,
                                                        context);
                                              
                                         
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Colors.deepOrangeAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                AppString.get(context).update(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // ElevatedButton.icon(
                                            //   style: ElevatedButton.styleFrom(
                                            //     primary: Theme.of(context)
                                            //         .colorScheme
                                            //         .secondary,
                                            //   ),
                                            //   onPressed: () {
                                            //     Map data = {
                                            //       "email": "patel@yopmail.com",
                                            //       "fullName": "parth patel"
                                            //     };

                                            //     updateProfileDetailsViewModel
                                            //         .updateProfileDetailsApi(
                                            //             token.toString(),
                                            //             data,
                                            //             context);
                                            //   },

                                            //   // _showUpdateButton()
                                            //   //     ?
                                            //   //     : null,
                                            //   icon: Icon(Icons.save),
                                            //   label: Text(
                                            //     AppString.get(context).update(),

                                            //   ),
                                            // )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: AppString.get(context)
                                                  .hintFullName(),
                                              labelText: AppString.get(context)
                                                  .hintFullName(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            controller: nameCtrl,
                                            // onChanged: (value) {
                                            //   setState(() {
                                            //     newUser?.userFullname = value;
                                            //   });
                                            // },
                                            validator: (value) =>
                                                value == null ||
                                                        value.length < 5
                                                    ? AppString.get(context)
                                                        .errorFullName()
                                                    : null,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: AppString.get(context)
                                                  .email(),
                                              labelText: AppString.get(context)
                                                  .email(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            controller: emailCtrl,
                                            // onChanged: (value) {
                                            //   setState(() {
                                            //     newUser?.userEmail = value;
                                            //   });
                                            // },
                                            validator: (value) =>
                                                EmailValidator.validate(value!)
                                                    ? null
                                                    : AppString.get(context)
                                                        .errorEmail(),
                                          ),
                                        )
                                    
                                    
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  void reloadProfile() {
    setState(() {
      // pageStatus = Utils.PageStatus.PROGRESS;
    });

    // networkApi.getUserProfile(context: context).then((value) {
    //   if (value.status) {
    //     oldUser = User.fromJson(value.data);
    //     nameCtrl.text = oldUser.userFullname!;
    //     emailCtrl.text = oldUser.userEmail!;
    //     newUser = oldUser.copyWith();
    //     setState(() {
    //       pageStatus = Utils.PageStatus.SUCCESS;
    //     });
    //   } else {
    //     setState(() {
    //       pageStatus = Utils.PageStatus.ERROR;
    //       pageError = value.message;
    //     });
    //   }
    // }).catchError((error) {
    //   setState(() {
    //     pageStatus = Utils.PageStatus.ERROR;
    //     pageError = error;
    //   });
    // });
  }

  void _updateProfile() {}

  bool _showUpdateButton() {
    return newUser != oldUser;
  }
}
