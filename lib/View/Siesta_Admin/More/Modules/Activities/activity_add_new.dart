import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/SharedPreferences/sharePreference.dart';
import 'package:siestaamsapp/View_Model/More_View_Model/Modules_view_model/Activities_View_Model/addNewActivity_view_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class ActivityAddNewPage extends StatefulWidget {
  const ActivityAddNewPage({super.key});

  @override
  State<ActivityAddNewPage> createState() => _ActivityAddNewPageState();
}

class _ActivityAddNewPageState extends State<ActivityAddNewPage> {
  var _nameController = TextEditingController();
  var _descController = TextEditingController();
  var _msdController = TextEditingController();
  bool isImageRequired = true;
  UserPreferences userPreference = UserPreferences();

  dynamic UserData;
  String? token;
  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _msdController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final addNewActivityViewModel =
        Provider.of<AddNewActivityViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        titleSpacing: 0,
        title: Text(
          AppString.get(context).addNewActivity(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map data = {
            "activityName": _nameController.text.toString(),
            "activityDescription": _descController.text.toString(),
            "maxSkipTimeoutDays": _msdController.text.toString(),
            "isImage@required": isImageRequired.toString(),
          };
          addNewActivityViewModel.addNewActivityApi(
              token.toString(), data, context);
        },
        backgroundColor: appSecondaryColor,
        mini: true,
        child: Icon(Icons.done),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              controller: _nameController,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: AppString.get(context).activity(),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: AppString.get(context).description()),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _msdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: AppString.get(context).maxSkipTimeoutDays()),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Checkbox(
                  value: isImageRequired,
                  onChanged: (value) {
                    setState(() {
                      isImageRequired = value!;
                    });
                  },
                ),
                Text(
                  AppString.get(context).imageRequired(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FABAddUpdateActivity extends StatefulWidget {
  final TextEditingController nameController, descController, msdController;
  final num method;
  static final num methodAdd = 1;
  static final num methodUpdate = 2;
  final num? activityId;
  final bool? active, isImageRequired;
  final String token;

  _FABAddUpdateActivity({
    required this.method,
    required this.nameController,
    required this.descController,
    required this.msdController,
    required this.isImageRequired,
    required this.token,
    this.activityId,
    this.active,
  });

  @override
  State createState() => _FABAddUpdateActivityState();
}

class _FABAddUpdateActivityState extends State<_FABAddUpdateActivity> {
  void addNewActivity() {
    final addNewActivityViewModel =
        Provider.of<AddNewActivityViewModel>(context, listen: false);
    Map data;

    if (widget.method == _FABAddUpdateActivity.methodAdd) {
      showDialog(
          context: context,
          builder: (ctx) {
            return Util.getAlertDialog(
                context,
                AppString.get(context).confirm(),
                AppString.get(context).addNewActivity(),
                negativeText: AppString.get(context).cancel(),
                positiveText: AppString.get(context).ok(),
                positiveButton: () => {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return Util.getProgressDialog(context);
                          }),
                      data = {
                        "activityName":
                            widget.nameController.text.trim().toString(),
                        "activityDescription":
                            widget.descController.text.trim().toString(),
                        "maxSkipTimeoutDays": int.parse(
                          widget.msdController.text.trim().toString(),
                          radix: 10,
                        ),
                        "isImage@required": widget.isImageRequired.toString()
                      },
                      addNewActivityViewModel.addNewActivityApi(
                          widget.token.toString(), data, context)
                    });
          });
    } else if (widget.method == _FABAddUpdateActivity.methodUpdate) {
      showDialog(
          context: context,
          builder: (ctx) {
            return Util.getAlertDialog(
                context,
                AppString.get(context).confirm(),
                AppString.get(context).updateActivity(),
                negativeText: AppString.get(context).cancel(),
                positiveText: AppString.get(context).update(),
                positiveButton: () => {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return Util.getProgressDialog(context);
                          }),
                    });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: addNewActivity,
      mini: true,
      child: Icon(Icons.done),
    );
  }
}
