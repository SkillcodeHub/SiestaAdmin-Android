import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:sizer/sizer.dart';

final headerFontSize = 15.sp;
final titleFontSize = 12.sp;
final descriptionFontSize = 10.sp;
final subDescriptionFontSize = 8.sp;

Color getActivityExecutionStatusColor({
  required String status,
  required String createdDate,
  String? deadlineDate,
  String? desiredExecutionStatus,
}) {
  var today = DateTime(DateTime.now().toLocal().year,
      DateTime.now().toLocal().month, DateTime.now().toLocal().day);

  var compareDate;
  if (deadlineDate == null) {
    var parsed = DateTime.parse(createdDate).toLocal();
    compareDate = DateTime(parsed.year, parsed.month, parsed.day);
  } else {
    var parsed = DateTime.parse(deadlineDate).toLocal();
    compareDate = DateTime(parsed.year, parsed.month, parsed.day);
  }
  var result = today.isAfter(compareDate);
  Color statusColor;
  switch (status.toLowerCase()) {
    case 'active':
      // {
      //   statusColor = result ? Colors.redAccent.shade400 : Colors.black;
      {
        if (desiredExecutionStatus?.toLowerCase() == "delayed") {
          statusColor = Colors.redAccent.shade400;
        } else {
          statusColor = result ? Colors.redAccent.shade400 : Colors.black;
        }

        break;
      }
    case 'running':
      {
        statusColor = result ? Colors.redAccent.shade400 : Colors.blue;
        break;
      }
    case 'completed':
      {
        statusColor = Colors.green;
        break;
      }
    case 'delayed':
      {
        statusColor = Colors.redAccent.shade400;
        break;
      }
    case 'skipped':
      {
        statusColor = result ? Colors.redAccent.shade400 : Colors.yellow;
        break;
      }
    default:
      {
        statusColor = result ? Colors.redAccent.shade400 : Colors.black;
        break;
      }
  }
  return statusColor;
}

// List<T> getList<T>(dynamic data) {
//   if (T == Activity) {
//     return (data as List).map((i) => Activity.fromJson(i)).toList() as List<T>;
//   }
// }

void showSnackMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

enum PageStatus { PROGRESS, SUCCESS, ERROR, IDLE }

Future<Map<Permission, PermissionStatus>> permissionMultiModal({
  bool forceRequest = false,
  required List<Permission> permissions,
}) async {
  if (forceRequest) {
    return permissions.request();
  } else {
    Map<Permission, PermissionStatus> map = Map();
    for (var element in permissions) {
      var status = await element.status;
      map.putIfAbsent(element, () => status);
    }
    return map;
  }
}

Future<bool> permissionModelStorage({bool forceRequest = false}) async {
  return Permission.storage.isGranted.then((value) async {
    if (value) {
      return true;
    } else {
      if (forceRequest) {
        return await Permission.storage.request().then((value) {
          return value.isGranted;
        });
      } else {
        return false;
      }
    }
  });
}

Future<bool> permissionModelCamera({bool forceRequest = false}) async {
  return Permission.camera.isGranted.then((value) async {
    if (value) {
      return true;
    } else {
      if (forceRequest) {
        return await Permission.camera.request().then((value) {
          return value.isGranted;
        });
      } else {
        return false;
      }
    }
  });
}

String getErrorMessage(BuildContext context, dynamic error) {
  if (error == null) {
    return AppString.get(context).somethingWentWrong();
  }
  if (error.runtimeType == SocketException) {
    return AppString.get(context).connectivityProblem();
  }
  if (error.runtimeType == Exception) {
    return (error as Exception).toString();
  }
  return error.toString();
}

Widget getErrorView(BuildContext context, {String? error, callback}) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(error ?? AppString.get(context).somethingWentWrong(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontSize: 18)),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            child: Text(
              AppString.get(context).retry(),
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            style: ElevatedButton.styleFrom(
              primary: appSecondaryColor,
            ),
            onPressed: callback,
          )
        ],
      ),
    ),
  );
}

Widget getProgressView(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppString.get(context).pleaseWait(),
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          SizedBox(
            height: 16,
          ),
          CircularProgressIndicator()
        ],
      ),
    ),
  );
}

Widget getEmptyDataView(BuildContext context,
    {String? error,
    String? assetImagePath,
    String svgAssetImagePath = 'asset/images/empty_pocket_man.svg',
    String? retryButtonText,
    bool showRetryButton = true,
    callback}) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            padding: EdgeInsets.all(16),
            child: assetImagePath != null
                ? Image.asset(
                    assetImagePath,
                    height: 200,
                    width: 200,
                    semanticLabel: 'Placeholder',
                  )
                : SvgPicture.asset(
                    svgAssetImagePath,
                    height: 200,
                    width: 200,
                    semanticsLabel: 'Placeholder',
                  ),
          ),
          Text(error ?? AppString.get(context).emptyData(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontSize: 18)),
          SizedBox(
            height: 8,
          ),
          if (showRetryButton)
            ElevatedButton(
              child: Text(
                retryButtonText ?? AppString.get(context).retry(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                primary: appSecondaryColor,
              ),
              onPressed: callback,
            )
        ],
      ),
    ),
  );
}

AlertDialog getAlertDialog(
  BuildContext context,
  String? title,
  dynamic message, {
  Function? positiveButton,
  String? positiveText,
  Function? negativeButton,
  String? negativeText,
}) {
  return AlertDialog(
    title: Text(
      title ?? AppString.get(context).message(),
    ),
    content: Text(message),
    actions: <Widget>[
      negativeText != null
          ? TextButton(
              onPressed:
                  // negativeButton ??
                  () {
                Navigator.of(context).pop();
              },
              child: Text(
                negativeText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: appSecondaryColor),
              ),
            )
          : SizedBox(),
      TextButton(
        onPressed:
            //  positiveButton ??
            () {
          Navigator.of(context).pop();
        },
        child: Text(
          positiveText?.toUpperCase() ?? AppString.get(context).ok(),
          style: Theme.of(context)
              .textTheme
              .button
              ?.copyWith(color: appSecondaryColor),
        ),
      )
    ],
  );
}

Widget getProgressDialog(BuildContext context, {String? title}) {
  return AlertDialog(
    title: Text(title ?? AppString.get(context).appHeadingAdmin()),
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(
          width: 8,
        ),
        Text(AppString.get(context).pleaseWait())
      ],
    ),
  );
}

PreferredSize? getAppbarBottomSearchView({
  String? label,
  required bool showFilterView,
  required TextEditingController searchController,
  required Function(String) onSearchChanged,
}) {
  return !showFilterView
      ? null
      : PreferredSize(
          preferredSize: Size(double.maxFinite, 56),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: searchController,
                  autofocus: true,
                  onFieldSubmitted: onSearchChanged,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged("null");
                      },
                    ),
                    labelText: label,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
            ),
          ),
        );
}
