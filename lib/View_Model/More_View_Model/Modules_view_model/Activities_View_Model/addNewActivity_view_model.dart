import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siestaamsapp/Repository/More_Repository/Activity_repository/addNewActivity_repository.dart';
import 'package:sizer/sizer.dart';

class AddNewActivityViewModel with ChangeNotifier {
  final _myRepo = AddNewActivityRepository();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _addNewActivityDataLoading = false;
  bool get addNewActivityLoading => _addNewActivityDataLoading;

  setAddNewActivityDataLoading(bool value) {
    _addNewActivityDataLoading = value;
    notifyListeners();
  }

  Future<void> addNewActivityApi(
      String token, dynamic data, BuildContext context) async {
    setLoading(true);
    final addNewActivityViewModel =
        Provider.of<AddNewActivityViewModel>(context, listen: false);
    await _myRepo.addNewActivityapi(token, data).then((value) {
      if (value['status'] == true) {
        Navigator.pop(context);
        setLoading(false);
        addNewActivityViewModel.setAddNewActivityDataLoading(false);

        if (kDebugMode) {
          print(value.toString());
        }
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Center(
                    child: Text(
                      'Success',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: Text(
                'New Activity Added',
                style: TextStyle(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                SizedBox(
                  width: 80.w,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
      ;
    }).onError((error, stackTrace) {
      addNewActivityViewModel.setAddNewActivityDataLoading(false);

      setLoading(false);
      String? message;

      String jsonString = error.toString();

      // Find the start and end index of the JSON string
      int startIndex = jsonString.indexOf('{');
      int endIndex = jsonString.lastIndexOf('}');

      // Extract the JSON substring
      String jsonSubstring = jsonString.substring(startIndex, endIndex + 1);

      // Parse the JSON substring
      Map<String, dynamic> jsonResponse = json.decode(jsonSubstring);

      // Access the "message" field
      message = jsonResponse['message'];

      // Print the message
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Center(
                  child: Text(
                    'Aleart!',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              message.toString(),
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              SizedBox(
                width: 80.w,
                child: ElevatedButton(
                  child: Text(
                    'OK',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
